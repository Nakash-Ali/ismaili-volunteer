defmodule VolunteerWeb.AuthController do
  use VolunteerWeb, :controller
  alias VolunteerWeb.UserSession

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
    |> UserSession.logout()
    |> put_flash(:info, "You have been logged out!")
    |> redirect(to: RouterHelpers.index_path(conn, :index))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: RouterHelpers.auth_path(conn, :login))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Volunteer.Accounts.Auth.upsert_authenticated_user(auth) do
      {:ok, user} ->
        conn
        |> UserSession.login(user)
        |> put_flash(:info, "Successfully authenticated.")
        |> redirect(to: UserSession.get_redirect(conn))

      {:error, :auth_email_domain_not_allowed} ->
        conn
        |> put_flash(:error, "Email domain not permitted to login.")
        |> redirect(to: RouterHelpers.auth_path(conn, :login))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Failed to login.")
        |> redirect(to: RouterHelpers.auth_path(conn, :login))
    end
  end
end
