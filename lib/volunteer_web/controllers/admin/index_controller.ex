defmodule VolunteerWeb.Admin.IndexController do
  use VolunteerWeb, :controller
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  plug :track,
    resource: "index"

  def index(conn, _params) do
    conn
    # TODO: this is a hack to reduce noise in Sentry, fix it
    |> Plug.Conn.put_private(:conn_permissions, true)
    |> render("index.html")
  end
end
