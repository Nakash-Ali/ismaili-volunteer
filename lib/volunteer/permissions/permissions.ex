defmodule Volunteer.Permissions do
  import Ecto.Query, warn: false
  alias Volunteer.Permissions.HardcodedRoles
  alias Volunteer.Permissions.Ruleset

  def is_allowed?(user, action) do
    is_allowed?(user, action, nil)
  end

  def is_allowed?(user, [:admin | _] = action, subject) do
    user
    |> annotate_group_roles_for_user()
    |> annotate_region_roles_for_user()
    |> Ruleset.evaluate(action, subject, Ruleset.admin_ruleset())
    |> case do
      :allow -> true
      :deny -> false
    end
  end

  def annotate_group_roles_for_user(user) do
    Map.put(
      user,
      :group_roles,
      get_for_user(user, :group)
    )
  end

  def annotate_region_roles_for_user(user) do
    Map.put(
      user,
      :region_roles,
      get_for_user(user, :region)
    )
  end

  def get_for_user(user, scope, role_types_to_include) do
    user
    |> get_for_user(scope)
    |> Enum.filter(fn {_group_id, role_type} ->
      Enum.member?(role_types_to_include, role_type)
    end)
    |> Enum.into(%{})
  end

  def get_for_user(user, :group) do
    HardcodedRoles.group_roles_for_user(user)
  end

  def get_for_user(user, :region) do
    HardcodedRoles.region_roles_for_user(user)
  end

  def get_all_allowed_users(action, subject, get_all_users \\ &Volunteer.Accounts.get_all_users/0) do
    get_all_users.()
    |> Enum.filter(fn user ->
      user
      |> annotate_group_roles_for_user()
      |> annotate_region_roles_for_user()
      |> is_allowed?(action, subject)
    end)
  end
end
