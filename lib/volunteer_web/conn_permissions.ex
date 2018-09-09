defmodule VolunteerWeb.ConnPermissions do
  alias VolunteerWeb.UserSession

  defmodule NotAllowedError do
    defexception message: "forbidden to access this resource", plug_status: 403
  end

  def ensure_allowed!(%Plug.Conn{} = conn, action, subject \\ nil) do
    case is_allowed?(conn, action, subject) do
      true ->
        conn

      false ->
        raise NotAllowedError
    end
  end

  def is_allowed?(%Plug.Conn{} = conn, action, subject \\ nil) do
    user = UserSession.get_user(conn)
    Volunteer.Permissions.is_allowed?(user, action, subject)
  end
end
