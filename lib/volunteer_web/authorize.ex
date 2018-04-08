defmodule VolunteerWeb.Authorize do
  alias Volunteer.Permissions.Abilities
  alias VolunteerWeb.Session
  
  @assign_to :resource
  
  def validate_permissions_before_action(%Plug.Conn{params: params} = conn, opts) do
    action = Phoenix.Controller.action_name(conn)
    user = Session.get_user(conn)
    abilities_module =
      Keyword.fetch!(opts, :abilities)
      |> get_abilities_module
    resource =
      Keyword.get(opts, :loader)
      |> load_resource(action, params)
    subject = 
      case resource do
        nil -> Keyword.fetch!(opts, :schema)
        _ -> resource
      end
    case abilities_module.can?(user, action, subject) do
      true ->
        case resource do
          nil -> conn
          %{} -> conn |> Plug.Conn.assign(@assign_to, resource)
        end
      false ->
        VolunteerWeb.FallbackController.call(conn, {:error, :not_allowed})
    end
  end
  
  def is_allowed?(conn, abilities, action, subject) do
    user = Session.get_user(conn)
    abilities_module = get_abilities_module(abilities)
    abilities_module.can?(user, action, subject)
  end
  
  defp get_abilities_module(:admin) do Abilities.Admin end
  defp get_abilities_module(:public) do Abilities.Public end
  
  defp load_resource(nil, _action, _params) do nil end
  defp load_resource(loader, action, params) do loader.(action, params) end
end
