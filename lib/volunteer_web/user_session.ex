defmodule VolunteerWeb.UserSession do
  import Plug.Conn
  alias VolunteerWeb.Router.Helpers
  alias Volunteer.Accounts

  @mock_sessions_user_id 1

  def login(conn, %Accounts.User{} = user) do
    put_session(conn, :current_user_id, user.id)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def put_redirect(conn) do
    put_session(conn, :redirect_url, conn.request_path)
  end

  def get_redirect(conn) do
    get_session(conn, :redirect_url) || Helpers.admin_index_path(conn, :index)
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

  def get_current_user_id(conn) do
    case Plug.Conn.get_session(conn, :current_user_id) do
      nil ->
        if VolunteerWeb.UserSession.should_mock_sessions?() do
          @mock_sessions_user_id
        else
          nil
        end

      id ->
        id
    end
  end

  def should_mock_sessions?() do
    Application.get_env(:volunteer, :mock_sessions, false) == true and Mix.env() == :dev
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
          |> Phoenix.Controller.redirect(to: Helpers.auth_path(conn, :login))
          |> Plug.Conn.halt()
      end
    end
  end
end
