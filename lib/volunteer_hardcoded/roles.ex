defmodule VolunteerHardcoded.Roles do
  @roles_by_scope %{
    region: VolunteerHardcoded.Regions.take_from_all!([:roles]) |> Enum.into(%{}),
    group: VolunteerHardcoded.Groups.take_from_all!([:roles]) |> Enum.into(%{})
  }

  @roles_by_primary_email VolunteerHardcoded.Roles.Reduce.by_primary_email(@roles_by_scope)

  @all_users Map.keys(@roles_by_primary_email)
  |> Enum.map(fn primary_email -> %VolunteerHardcoded.User{primary_email: primary_email} end)

  def scopes() do Map.keys(@roles_by_scope) end
  def roles_by_primary_email() do @roles_by_primary_email end
  def all_users() do @all_users end

  def scope_roles(scope, id) do
    @roles_by_scope
    |> Map.fetch!(scope)
    |> Map.get(id, %{})
  end

  def scope_roles(scope, id, role_types_to_include) do
    scope_roles(scope, id)
    |> Enum.filter(fn {_email, role_type} ->
      Enum.member?(role_types_to_include, role_type)
    end)
    |> Enum.into(%{})
  end

  def user_roles(%{primary_email: primary_email}, scope_type) do
    user_roles(primary_email, scope_type)
  end

  def user_roles(primary_email, scope_type) when is_binary(primary_email) do
    @roles_by_primary_email
    |> Map.get(primary_email, %{})
    |> Map.get(scope_type, %{})
  end

  def user_roles(user, scope_type, role_types_to_include) do
    user_roles(user, scope_type)
    |> Enum.filter(fn {_group_id, role_type} ->
      Enum.member?(role_types_to_include, role_type)
    end)
    |> Enum.into(%{})
  end
end
