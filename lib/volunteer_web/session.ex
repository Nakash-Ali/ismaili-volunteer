defmodule VolunteerWeb.Session do
  import Plug.Conn
  alias VolunteerWeb.Router.Helpers
  alias Volunteer.Accounts
  require Logger

  @mock_sessions_user_id 1

  def login(conn, %Accounts.User{} = user) do
    Logger.warn "Logging in user with id #{user.id}"
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
        Logger.warn "Did not find user_id in session, checking for mock"
        if VolunteerWeb.Session.should_mock_sessions?() do
          Logger.warn "SHOULD MOCK! mocking now"
          @mock_sessions_user_id
        else
          Logger.warn "No mocks, allowing nil"
          nil
        end

      id ->
        Logger.warn "Found id #{id} in session"
        id
    end
  end

  def should_mock_sessions?() do
    Application.get_env(:volunteer, :mock_sessions, false) == true and Mix.env() == :dev
  end

  defmodule Plugs do
    def load_current_user(conn, _) do
      Logger.warn "getting current_user_id from session"
      case VolunteerWeb.Session.get_current_user_id(conn) do
        nil ->
          Logger.warn "No current_user_id, returning"
          conn

        user_id ->
          Logger.warn "Loading current user with id #{user_id}"
          case Accounts.get_user(user_id) do
            nil ->
              Logger.warn "Did not find user! Logging out"
              VolunteerWeb.Session.logout(conn)

            user ->
              Logger.warn "Found user, putting user in session"
              VolunteerWeb.Session.put_user(conn, user)
          end
      end
    end

    def ensure_authenticated(conn, _) do
      case VolunteerWeb.Session.get_user(conn) do
        %Accounts.User{} ->
          Logger.warn "User exists in session, therefore user is authenticated"
          conn

        _ ->
          Logger.warn "User is not authenticated, redirecting to login page"
          conn
          |> VolunteerWeb.Session.put_redirect()
          |> Phoenix.Controller.put_flash(:error, "Please log in to view this page")
          |> Phoenix.Controller.redirect(to: Helpers.auth_path(conn, :login))
          |> Plug.Conn.halt()
      end
    end
  end
end
