defmodule VolunteerWeb.Admin.SystemController do
  use VolunteerWeb, :controller
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]

  # Plugs

  plug :authorize, action_root: [:admin, :system]

  # Actions

  def env(conn, _params) do
    render(
      conn,
      "data.html",
      data: System.get_env()
    )
  end

  def app(conn, _params) do
    render(
      conn,
      "data.html",
      data: :application.loaded_applications()
            |> Enum.map(fn {app, _description, _version} ->
              {app, :application.get_all_env(app)}
            end)
            |> Enum.into(%{})
    )
  end

  def endpoint(conn, _params) do
    render(
      conn,
      "data.html",
      data: :ets.tab2list(VolunteerWeb.Endpoint)
    )
  end

  def req_headers(conn, _params) do
    render(
      conn,
      "data.html",
      data: conn.req_headers
    )
  end

  def spoof(conn, %{"user_id" => user_id}) do
    user = Volunteer.Accounts.get_user!(user_id)

    conn
    |> VolunteerWeb.UserSession.login(user)
    |> VolunteerWeb.FlashHelpers.put_paragraph_flash(:info, "Successfully authenticated as #{VolunteerWeb.Presenters.Title.plain(user)}")
    |> redirect(to: RouterHelpers.admin_index_path(conn, :index))
  end
end
