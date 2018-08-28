defmodule VolunteerWeb.Authorize do
  alias Volunteer.Permissions.Abilities
  alias VolunteerWeb.Session

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
    user = Session.get_user(conn)
    Abilities.can?(user, action, subject)
  end
end
