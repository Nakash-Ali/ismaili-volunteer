defmodule VolunteerWeb.Admin.IndexController do
  use VolunteerWeb, :controller
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  plug :authorize,
    action_root: [:admin]
  plug :track,
    resource: "index"

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
