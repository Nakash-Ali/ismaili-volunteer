defmodule Volunteer.Permissions.HardcodedRoles do
  # @role_types [
  #   "admin"
  # ]

  @roles_by_region %{
    # Canada
    1 => %{
      "___@iicanada.net" => "admin",
    },
    # Ontario
    2 => %{
      "___@iicanada.net" => "admin",
    }
  }

  @roles_by_group %{
    # Council for Ontario
    1 => %{},
    # Council for Canada
    2 => %{},
    # Aga Khan Education Board for Ontario
    3 => %{},
    # Aga Khan Health Board for Ontario
    4 => %{
      "aly-khan.lalani@iicanada.net" => "admin",
      "anar.pardhan@iicanada.net" => "admin",
      "salima.k.shariff@iicanada.net" => "admin"
    },
    # ITREB Ontario
    5 => %{},
    # Economic Planning Board (EPB) Ontario
    6 => %{
      "farhad.shariff@iicanada.net" => "admin",
      "amreen.poonawala@iicanada.net" => "admin"
    }
  }

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
