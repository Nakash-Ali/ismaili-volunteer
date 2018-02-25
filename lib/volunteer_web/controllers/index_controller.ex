defmodule VolunteerWeb.IndexController do
  use VolunteerWeb, :controller

  def index(conn, _params) do
    session = fetch_session(conn)
    json(conn, %{status: 200, session: inspect(session)})
  end
end
