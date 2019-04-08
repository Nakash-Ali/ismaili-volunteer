defmodule Volunteer.Permissions do
  alias Volunteer.Permissions.Ruleset

  def is_allowed?(user, action) do
    is_allowed?(user, action, nil)
  end

  def is_allowed?(user, [:admin | _] = action, subject, annotate_roles_for_user_func \\ &annotate_roles_for_user/2) do
    user
    |> annotate_roles_for_user_func.(:if_absent)
    |> Ruleset.evaluate(action, subject, Ruleset.admin_ruleset())
    |> case do
      :allow -> true
      :deny -> false
    end
  end

  def annotate_roles_for_user(user_or_users, condition \\ :always)

  def annotate_roles_for_user(users, condition) when is_list(users) do
    Enum.map(users, &annotate_roles_for_user(&1, condition))
  end

  def annotate_roles_for_user(user, :if_absent) do
    user
    |> Map.put_new_lazy(:group_roles, fn -> __MODULE__.user_roles(user, :group) end)
    |> Map.put_new_lazy(:region_roles, fn -> __MODULE__.user_roles(user, :region) end)
  end

  def annotate_roles_for_user(user, :always) do
    user
    |> Map.put(:group_roles, __MODULE__.user_roles(user, :group))
    |> Map.put(:region_roles, __MODULE__.user_roles(user, :region))
  end

  def get_all_allowed_users(
    action,
    subject,
    is_allowed_func \\ &is_allowed?/3,
    annotate_roles_for_user_func \\ &annotate_roles_for_user/2,
    all_users_func \\ &VolunteerHardcoded.Roles.all_users/0,
    hydrate_actual_users_func \\ &VolunteerHardcoded.User.hydrate_actual_users/1
  ) do
    all_users_func.()
    |> annotate_roles_for_user_func.(:always)
    |> Enum.filter(&is_allowed_func.(&1, action, subject))
    |> hydrate_actual_users_func.()
    |> annotate_roles_for_user_func.(:if_absent)
  end

  def reject_users_with_any_roles(users, role_pairs_to_reject) do
    Enum.reject(users, &user_has_any_roles?(&1, role_pairs_to_reject))
  end

  def user_has_any_roles?(user, role_pairs) do
    user_has_roles?(user, role_pairs) |> Enum.any?()
  end

  def user_has_all_roles?(user, role_pairs) do
    user_has_roles?(user, role_pairs) |> Enum.all?()
  end

  defp user_has_roles?(user, role_pairs) do
    Enum.map(role_pairs, fn {scope, role} ->
      user
      |> Map.fetch!(:"#{scope}_roles")
      |> Map.values()
      |> Enum.member?(role)
    end)
  end

  def emails_from_scope_roles(scope_roles_map) do
    Map.keys(scope_roles_map)
  end

  defdelegate scope_roles(scope, id),
    to: VolunteerHardcoded.Roles

  defdelegate scope_roles(scope, id, role_types_to_include),
    to: VolunteerHardcoded.Roles

  defdelegate user_roles(id, scope_type),
    to: VolunteerHardcoded.Roles

  defdelegate user_roles(id, scope_type, role_types_to_include),
    to: VolunteerHardcoded.Roles
end
