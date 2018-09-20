defmodule VolunteerWeb.Admin.UsersController do
  use VolunteerWeb, :controller
  alias Volunteer.Accounts
  alias VolunteerWeb.ConnPermissions

  # Plugs

  plug :authorize

  def authorize(conn, _opts) do
    ConnPermissions.ensure_allowed!(conn, [:admin, :users])
  end

  # Controller Actions

  def index(conn, _params) do
    users = Accounts.get_all_users()
    render(conn, "index.html", users: users)
  end
end
