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

  def save_redirect(conn) do
    put_session(conn, :redirect_url, conn.request_path)
  end

  def get_redirect(conn) do
    get_session(conn, :redirect_url) || Helpers.index_path(conn, :index)
  end

  defmodule Plugs do
    import Phoenix.Controller

    def assign_current_user(conn, _) do
      case get_session(conn, :current_user_id) do
        nil -> conn
        id ->
          try do
            user = Accounts.get_user!(id)
            assign(conn, :current_user, user)
          catch
            _ -> VolunteerWeb.Session.logout(conn)
          end
      end
    end

    def ensure_authenticated(conn, _) do
      case conn.assigns[:current_user] do
        %Accounts.User{} ->
          conn
        _ ->
          conn
          |> VolunteerWeb.Session.save_redirect
          |> put_flash(:error, "Please log in to view this page")
          |> redirect(to: Helpers.auth_path(conn, :login))
          |> halt
      end
    end
  end
end
