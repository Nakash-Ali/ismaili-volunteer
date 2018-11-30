defmodule VolunteerWeb.UserSession do
  import Plug.Conn
  alias VolunteerWeb.Router.Helpers, as: RouterHelpers
  alias Volunteer.Accounts

  def login(conn, %Accounts.User{} = user) do
    VolunteerWeb.Services.Analytics.track_event("Session", "login", nil, nil)

    put_session(conn, :current_user_id, user.id)
  end

  def logout(conn) do
    VolunteerWeb.Services.Analytics.track_event("Session", "logout", nil, nil)

    configure_session(conn, drop: true)
  end

  def put_redirect(conn) do
    put_session(conn, :redirect_url, conn.request_path)
  end

  def get_redirect(conn) do
    get_session(conn, :redirect_url) || RouterHelpers.admin_index_path(conn, :index)
  end

  def put_user(conn, user) do
    assign(conn, :current_user, user)
  end

  def get_user(conn) do
    conn.assigns[:current_user]
  end

  def logged_in?(conn) do
    case get_user(conn) do
      %Accounts.User{} -> true
      _ -> false
    end
  end

  if Enum.member?([:dev, :test], Mix.env()) and Application.get_env(:volunteer, :mock_sessions, false) == true do
    def get_current_user_id(conn) do
      conn.assigns[:current_user_id] || 1
    end
  else
    def get_current_user_id(conn) do
      Plug.Conn.get_session(conn, :current_user_id)
    end
  end

  defmodule Plugs do
    def load_current_user(conn, _) do
      case VolunteerWeb.UserSession.get_current_user_id(conn) do
        nil ->
          conn

        user_id ->
          case Accounts.get_user(user_id) do
            nil ->
              conn
              |> VolunteerWeb.UserSession.logout()

            user ->
              conn
              |> VolunteerWeb.UserSession.put_user(user)
          end
      end
    end

    def ensure_authenticated(conn, _) do
      case VolunteerWeb.UserSession.get_user(conn) do
        %Accounts.User{} ->
          conn

        _ ->
          conn
          |> VolunteerWeb.UserSession.put_redirect()
          |> Phoenix.Controller.put_flash(:error, "Please log in to view this page")
          |> Phoenix.Controller.redirect(to: RouterHelpers.auth_path(conn, :login))
          |> Plug.Conn.halt()
      end
    end
  end
end
