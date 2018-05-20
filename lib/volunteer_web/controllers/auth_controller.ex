defmodule VolunteerWeb.AuthController do
  use VolunteerWeb, :controller
  alias VolunteerWeb.Session
  alias VolunteerWeb.Router

  plug Ueberauth
  
  def request(conn, _params) do
    conn
    |> render("login.html")
  end

  def login(conn, _params) do
    conn
    |> render("login.html")
  end

  def logout(conn, _params) do
    conn
    |> Session.logout()
    |> put_flash(:info, "You have been logged out!")
    |> redirect(to: Router.Helpers.index_path(conn, :index))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: Router.Helpers.auth_path(conn, :login))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Volunteer.Accounts.Auth.upsert_together_and_return(auth) do
      {:ok, user} ->
        conn
        |> Session.login(user)
        |> put_flash(:info, "Successfully authenticated.")
        |> redirect(to: Session.get_redirect(conn))

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Router.Helpers.auth_path(conn, :login))
    end
  end
end
