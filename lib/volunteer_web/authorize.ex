defmodule VolunteerWeb.Authorize do
  alias Volunteer.Permissions.Abilities
  alias VolunteerWeb.Session
  
  @abilities_module_mapping %{
    admin: Abilities.Admin,
    public: Abilities.Public,
  }

  def is_allowed?(%Plug.Conn{params: params} = conn, opts) do
    action = Phoenix.Controller.action_name(conn)

    resource =
      Keyword.get(opts, :loader)
      |> load_resource(action, params)

    subject =
      case resource do
        nil -> Keyword.fetch!(opts, :schema)
        _ -> resource
      end

    case is_allowed?(conn, Keyword.fetch!(opts, :abilities), action, subject) do
      true -> {true, resource}
      false -> false
    end
  end

  def is_allowed?(conn, abilities, action, subject) do
    user = Session.get_user(conn)
    abilities_module =
      case Kernel.function_exported?(abilities, :can?, 3) do
        true ->
          abilities
        false ->
          Map.get(@abilities_module_mapping, abilities)
      end
    abilities_module.can?(user, action, subject)
  end

  def validate_permissions(conn, opts) do
    case is_allowed?(conn, opts) do
      {true, _resource} -> conn
      false -> VolunteerWeb.FallbackController.call(conn, {:error, :not_allowed})
    end
  end

  def validate_permissions_and_assign_resource(conn, opts) do
    case is_allowed?(conn, opts) do
      {true, resource} ->
        assign_resource?(conn, resource, Keyword.get(opts, :assign_to))

      false ->
        VolunteerWeb.FallbackController.call(conn, {:error, :not_allowed})
    end
  end
  
  def assign_resource?(conn, resource, key) when is_map(resource) do
    Plug.Conn.assign(conn, key, resource)
  end

  def assign_resource?(conn, _resource, _key) do
    conn
  end

  defp load_resource(nil, _action, _params) do
    nil
  end

  defp load_resource(loader, action, params) do
    loader.(action, params)
  end
end
