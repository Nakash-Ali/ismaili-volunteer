defmodule VolunteerWeb.SessionIdentifier do
  @key :current_session_id

  def get_id(conn) do
    Plug.Conn.get_session(conn, @key)
  end

  def put_id(conn) do
    Plug.Conn.put_session(conn, @key, VolunteerUtils.Id.generate_unique_id(64))
  end

  defmodule Plugs do
    alias VolunteerWeb.SessionIdentifier

    def ensure_unique_session_identifier(conn, _params) do
      case SessionIdentifier.get_id(conn) do
        nil ->
          SessionIdentifier.put_id(conn)
        _ ->
          conn
      end
    end
  end
end
