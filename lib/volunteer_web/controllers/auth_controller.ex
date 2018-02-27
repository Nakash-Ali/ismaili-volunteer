defmodule VolunteerWeb.AuthController do
  use VolunteerWeb, :controller
  alias VolunteerWeb.Session
  alias VolunteerWeb.Router.Helpers
  alias Ueberauth.Strategy.Helpers

  plug Ueberauth

  def login(conn, _params) do
    conn
    |> render("index.html")
  end

  def logout(conn, _params) do
    conn
    |> Session.logout
    |> put_flash(:info, "You have been logged out!")
    |> redirect(to: Helpers.index_path(conn, :index))
  end

  def request(conn, _params) do
    conn
    |> put_flash(:error, "Authentication misconfigured!")
    |> redirect(to: Helpers.auth_path(conn, :login))
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: Helpers.auth_path(conn, :login))
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Volunteer.Accounts.Auth.upsert_together_and_return(auth) do
      {:ok, user} ->
        conn
        |> Session.login(user)
        |> put_flash(:info, "Successfully authenticated.")
        |> redirect(to: Session.redirect_url(conn))
      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Helpers.auth_path(conn, :login))
    end
  end
end
