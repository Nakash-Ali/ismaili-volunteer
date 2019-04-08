defmodule Volunteer.Permissions do
  alias Volunteer.Permissions.Ruleset

  def is_allowed?(user, action) do
    is_allowed?(user, action, nil)
  end

  def is_allowed?(user, [:admin | _] = action, subject, annotate_roles_for_user_func \\ &annotate_roles_for_user/1) do
    user
    |> annotate_roles_for_user_func.()
    |> Ruleset.evaluate(action, subject, Ruleset.admin_ruleset())
    |> case do
      :allow -> true
      :deny -> false
    end
  end

  def annotate_roles_for_user(user) do
    user
    |> Map.put(:group_roles, __MODULE__.user_roles(user, :group))
    |> Map.put(:region_roles, __MODULE__.user_roles(user, :region))
  end

  def get_all_allowed_users(
    action,
    subject,
    is_allowed_func \\ &is_allowed?/3,
    all_users_func \\ &VolunteerHardcoded.Roles.all_users/0,
    hydrate_actual_users_func \\ &VolunteerHardcoded.User.hydrate_actual_users/1
  ) do
    all_users_func.()
    |> Enum.filter(&is_allowed_func.(&1, action, subject))
    |> hydrate_actual_users_func.()
  end

  def reject_roles(roles, role_types_to_reject) do

  end

  defdelegate region_roles(id),
    to: VolunteerHardcoded.Roles

  defdelegate region_roles(id, role_types_to_include),
    to: VolunteerHardcoded.Roles

  defdelegate group_roles(id),
    to: VolunteerHardcoded.Roles

  defdelegate group_roles(id, role_types_to_include),
    to: VolunteerHardcoded.Roles

  defdelegate user_roles(id, scope_type),
    to: VolunteerHardcoded.Roles

  defdelegate user_roles(id, scope_type, role_types_to_include),
    to: VolunteerHardcoded.Roles
end
