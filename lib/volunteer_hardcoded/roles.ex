defmodule VolunteerHardcoded.Roles do
  @roles_by_region (VolunteerHardcoded.Regions.take_from_all!([:roles]) |> Enum.into(%{}))
  @roles_by_group (VolunteerHardcoded.Groups.take_from_all!([:roles]) |> Enum.into(%{}))

  def region_roles(region_id) do
    Map.get(@roles_by_region, region_id, %{})
  end

  def group_roles(group_id) do
    Map.get(@roles_by_group, group_id, %{})
  end

  def region_roles_for_user(user) do
    roles_for_user(@roles_by_region, user)
  end

  def group_roles_for_user(user) do
    roles_for_user(@roles_by_group, user)
  end

  def roles_for_user(roles_by_scope_type, %{primary_email: primary_email}) do
    Enum.reduce(roles_by_scope_type, %{}, fn {scope_id, scope_map}, user_roles ->
      case Map.get(scope_map, primary_email, nil) do
        nil ->
          user_roles

        role ->
          Map.put(user_roles, scope_id, role)
      end
    end)
  end
end
