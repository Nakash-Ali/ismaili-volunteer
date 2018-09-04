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
      HardcodedRoles.group_roles_for_user(user)
    )
  end

  def annotate_region_roles_for_user(user) do
    Map.put(
      user,
      :region_roles,
      HardcodedRoles.region_roles_for_user(user)
    )
  end
end
