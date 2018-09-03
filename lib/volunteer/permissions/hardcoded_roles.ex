defmodule Volunteer.Permissions.HardcodedRoles do
  @roles_by_region %{
    # Canada
    1 => %{
      "alizain.feerasta@iicanada.net" => "admin",
      "hussein.kermally@iicanada.net" => "admin"
    },
    # Ontario
    2 => %{
      "alizain.feerasta@iicanada.net" => "admin",
      "hussein.kermally@iicanada.net" => "admin"
    }
  }

  @roles_by_group %{}

  def region_roles_for_user(user) do
    roles_for_user(@roles_by_region, user)
  end

  def group_roles_for_user(user) do
    roles_for_user(@roles_by_group, user)
  end

  def roles_for_user(roles_by_scope, %{primary_email: primary_email}) do
    Enum.reduce(roles_by_scope, %{}, fn {scope_id, scope_map}, user_roles ->
      case Map.get(scope_map, primary_email, nil) do
        nil ->
          user_roles

        role ->
          Map.put(user_roles, scope_id, role)
      end
    end)
  end
end
