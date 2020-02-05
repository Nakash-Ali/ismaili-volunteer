defmodule VolunteerWeb.Admin.IndexController do
  use VolunteerWeb, :controller
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  plug :track,
    resource: "index"

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
