defmodule VolunteerWeb.Session do
  import Plug.Conn
  alias VolunteerWeb.Router.Helpers
  alias Volunteer.Accounts
  
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

  defmodule Plugs do
    import Phoenix.Controller

    def load_current_user(conn, _) do
      case get_session(conn, :current_user_id) do
        nil ->
          conn

        id ->
          try do
            user = Accounts.get_user!(id)
            VolunteerWeb.Session.put_user(conn, user)
          rescue
            _ -> VolunteerWeb.Session.logout(conn)
          end
      end
    end

    def ensure_authenticated(conn, _) do
      case VolunteerWeb.Session.get_user(conn) do
        %Accounts.User{} ->
          conn

        _ ->
          conn
          |> VolunteerWeb.Session.put_redirect()
          |> put_flash(:error, "Please log in to view this page")
          |> redirect(to: Helpers.auth_path(conn, :login))
          |> halt
      end
    end
  end
  
  defmodule DevPlugs do
    def load_current_user(conn, _) do
      user = Accounts.get_user!(1)
      VolunteerWeb.Session.put_user(conn, user)
    end
    
    def ensure_authenticated(conn, _) do
      conn
    end
  end
end
