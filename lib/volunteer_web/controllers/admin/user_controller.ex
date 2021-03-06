defmodule VolunteerWeb.Admin.UserController do
  use VolunteerWeb, :controller
  alias Volunteer.Accounts
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  # Plugs

  plug :authorize, action_root: [:admin, :user]
  plug :track,
    resource: "user"

  # Controller Actions

  def index(conn, _params) do
    users = Accounts.get_all_users()

    render(conn, "index.html", users: users)
  end
end
