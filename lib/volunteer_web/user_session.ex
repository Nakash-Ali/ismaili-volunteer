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

  def get_current_user_id(conn) do
    {:ok, Plug.Conn.get_session(conn, :current_user_id)}
  end

  defmodule Mocks do
    def get_from_assigns(conn) do
      {:ok, conn.assigns[:current_user_id]}
    end

    def get_default(_conn) do
      {:ok, 1}
    end
  end

  defmodule AuthToken do
    @salt_len 32
    @salt :crypto.strong_rand_bytes(@salt_len) |> Base.encode64() |> binary_part(0, @salt_len)

    @params_key "auth_token"

    @max_age 60 # in seconds

    def generate(conn, %Accounts.User{} = user) do
      Phoenix.Token.sign(conn, @salt, user.id)
    end

    def put_in_params(url, conn) do
      case VolunteerWeb.UserSession.get_user(conn) do
        nil ->
          raise "A user must be logged-in to generate an auth token for them"

        user ->
          token = generate(conn, user)
          VolunteerUtils.URL.put_in_query(url, @params_key, token)
      end
    end

    def get_from_params(conn = %{params: %{@params_key => token}}) when is_binary(token) do
      case Phoenix.Token.verify(conn, @salt, token, max_age: @max_age) do
        {:ok, user_id} ->
          {:ok, user_id}

        _ ->
          nil
      end
    end

    def get_from_params(_conn) do
      nil
    end
  end

  defmodule Mechanisms do
    @should_mock Enum.member?([:dev, :test], Mix.env()) and
                   Application.get_env(:volunteer, :mock_sessions, nil) == true

    @mechanisms %{
      {VolunteerWeb.UserSession, :get_current_user_id} => true,
      {VolunteerWeb.UserSession.AuthToken, :get_from_params} => true,
      {VolunteerWeb.UserSession.Mocks, :get_from_assigns} => @should_mock,
      {VolunteerWeb.UserSession.Mocks, :get_default} => @should_mock
    }

    @mechanisms_active @mechanisms
                       |> Enum.filter(fn {_mechanism, enabled?} -> enabled? end)
                       |> Enum.map(fn {mechanism, _enabled?} -> mechanism end)

    def active() do
      @mechanisms_active
    end
  end

  defmodule Plugs do
    def authenticate_user(conn, _) do
      Enum.reduce_while(Mechanisms.active(), conn, fn {module, func}, conn ->
        case apply(module, func, [conn]) do
          {:ok, user_id} when is_integer(user_id) ->
            case Accounts.get_user_for_session(user_id) do
              nil ->
                {:halt, conn}

              user ->
                {:halt, VolunteerWeb.UserSession.put_user(conn, user)}
            end

          _ ->
            {:cont, conn}
        end
      end)
    end

    def ensure_authenticated(conn, _) do
      case VolunteerWeb.UserSession.get_user(conn) do
        %Accounts.User{} ->
          conn

        _ ->
          conn
          |> VolunteerWeb.UserSession.put_redirect()
          |> VolunteerWeb.FlashHelpers.put_paragraph_flash(:error, "Please log in to view this page")
          |> Phoenix.Controller.redirect(to: RouterHelpers.auth_path(conn, :login))
          |> Plug.Conn.halt()
      end
    end

    def annotate_roles_for_user(conn, _) do
      case VolunteerWeb.UserSession.get_user(conn) do
        user = %Accounts.User{} ->
          VolunteerWeb.UserSession.put_user(conn, Volunteer.Permissions.annotate_roles_for_user(user, :lazy))

        _ ->
          conn
      end
    end
  end
end
