defmodule VolunteerWeb.ConnPermissions do
  alias VolunteerWeb.UserSession

  @action_name_mapping %{}

  defmodule NotAllowedError do
    defexception message: "forbidden to access this resource", plug_status: 403
  end

  defmodule NotPermissionedError do
    defexception message: "permissions not checked for this resource", plug_status: 500
  end

  defmodule Plugs do
    def ensure_permissioned(conn, _) do
      Plug.Conn.register_before_send(conn, fn conn ->
        case conn do
          %{private: %{conn_permissions: true}} ->
            conn

          conn ->
            VolunteerWeb.SentryHelper.capture_exception(conn, %NotPermissionedError{})
            conn
        end
      end)
    end
  end

  def authorize(conn, opts) do
    action_root = Keyword.fetch!(opts, :action_root)

    action_name_mapping = Map.merge(
      @action_name_mapping,
      Keyword.get(opts, :action_name_mapping, %{})
    )

    action_name = Phoenix.Controller.action_name(conn)
    action_name = Map.get(action_name_mapping, action_name, action_name)

    action = Enum.concat(action_root, [action_name])

    case Keyword.fetch(opts, :assigns_subject_key) do
      {:ok, key} ->
        ensure_allowed!(conn, action, Map.get(conn.assigns, key, nil))

      :error ->
        ensure_allowed!(conn, action)
    end
  end

  def ensure_allowed!(%Plug.Conn{} = conn, action, subject \\ nil) do
    case is_allowed?(conn, action, subject) do
      true ->
        Plug.Conn.put_private(conn, :conn_permissions, true)

      false ->
        raise NotAllowedError
    end
  end

  def is_allowed?(%Plug.Conn{} = conn, action, subject \\ nil) do
    user = UserSession.get_user(conn)
    Volunteer.Permissions.is_allowed?(user, action, subject)
  end
end
