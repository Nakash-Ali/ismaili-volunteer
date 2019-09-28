defmodule Volunteer.Permissions do
  alias Volunteer.Permissions.{Ruleset, Actions}
  alias Volunteer.Roles

  def is_allowed?(user, action) do
    is_allowed?(user, action, nil)
  end

  def is_allowed?(user, [:admin | _] = action, subject, annotate_roles_for_user_func \\ &annotate_roles_for_user/2) do
    Actions.is_valid!(action)

    user
    |> annotate_roles_for_user_func.(:lazy)
    |> Ruleset.evaluate(action, subject, Ruleset.admin_ruleset())
    |> case do
      :allow -> true
      :deny -> false
    end
  end

  def annotate_roles_for_user(user_or_users, condition \\ :eager)

  def annotate_roles_for_user(users, condition) when is_list(users) do
    Enum.map(users, &annotate_roles_for_user(&1, condition))
  end

  def annotate_roles_for_user(user, :lazy) do
    Map.put_new_lazy(user, :roles_by_subject, fn -> Roles.collated_roles_for_user(user.id) end)
  end

  def annotate_roles_for_user(user, :eager) do
    Map.put(user, :roles_by_subject, Roles.collated_roles_for_user(user.id))
  end

  def get_all_allowed_users(action, subject, all_users_func \\ &Volunteer.Roles.get_all_users_with_roles/0) do
    Enum.filter(all_users_func.(), &is_allowed?(&1, action, subject))
  end

  def filter_subjects(subjects, user, action) do
    Enum.filter(subjects, &is_allowed?(user, action, &1))
  end
end
