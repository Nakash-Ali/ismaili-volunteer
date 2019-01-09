defmodule VolunteerWeb.UserPrefs do
  @default_backends [
    {VolunteerWeb.UserPrefs.Backend.Params, %{}},
    {VolunteerWeb.UserPrefs.Backend.Session, %{key_prefix: "user_pref_"}}
  ]

  @private_key :user_prefs

  def get!(conn, key) do
    conn
    |> Map.fetch!(:private)
    |> Map.fetch(@private_key)
    |> case do
      {:ok, user_prefs} ->
        Map.fetch!(user_prefs, key)

      :error ->
        raise "UserPrefs must be fetched prior to access"
    end
  end

  def fetch_user_prefs(conn, prefs_config) when is_map(prefs_config) do
    fetch_user_prefs(conn, {prefs_config, @default_backends})
  end

  def fetch_user_prefs(conn, {prefs_config, backends}) when is_map(prefs_config) and is_list(backends) do
    {conn, prefs} =
      Enum.reduce(backends, {conn, %{}}, fn {backend_module, backend_config}, {curr_conn, curr_prefs} ->
        new_prefs =
          backend_module.get_prefs!(curr_conn, keys(prefs_config), backend_config)
          |> filter_and_normalize_prefs(prefs_config)
          |> Map.merge(curr_prefs)

        new_conn = backend_module.store_prefs!(curr_conn, new_prefs, backend_config)

        {new_conn, new_prefs}
      end)

    final_prefs =
      Map.merge(
        default_prefs(prefs_config),
        prefs
      )

    Plug.Conn.put_private(
      conn,
      @private_key,
      final_prefs
    )
  end

  defp keys(prefs_config) do
    Map.keys(prefs_config)
  end

  defp filter_and_normalize_prefs(raw_prefs, prefs_config) do
    Enum.reduce(raw_prefs, %{}, fn
      {_key, nil}, prefs ->
        prefs

      {key, raw_value}, prefs ->
        case Map.fetch(prefs_config, key) do
          {:ok, {type, _default}} ->
            case Ecto.Type.cast(type, raw_value) do
              {:ok, normalized_value} ->
                prefs |> Map.put(key, normalized_value)

              :error ->
                prefs
            end

          {:ok, _} ->
            raise "Invalid pref config for key:#{key}"

          :error ->
            prefs
        end
    end)
  end

  defp default_prefs(prefs_config) do
    prefs_config
    |> Enum.map(fn {key, {_type, default}} -> {key, default} end)
    |> Enum.into(%{})
  end

  defmodule Backend do
    @type conn :: Plug.Conn
    @type backend_config :: map
    @type prefs :: map
    @type prefs_config :: {atom, atom, any}
    @type keys :: [atom]

    @callback get_prefs!(conn, keys, backend_config) :: prefs
    @callback store_prefs!(conn, prefs, backend_config) :: conn
  end

  defmodule Backend.Params do
    @behaviour VolunteerWeb.UserPrefs.Backend

    @impl true
    def get_prefs!(%{params: params}, keys, _backend_config) do
      Enum.reduce(keys, %{}, fn key, prefs ->
        Map.put(
          prefs,
          key,
          Map.get(params, to_string(key), nil)
        )
      end)
    end

    @impl true
    def store_prefs!(conn, _prefs, _backend_config) do
      conn
    end
  end

  defmodule Backend.Session do
    @behaviour VolunteerWeb.UserPrefs.Backend

    @impl true
    def get_prefs!(conn, keys, backend_config) do
      Enum.reduce(keys, %{}, fn key, prefs ->
        Map.put(
          prefs,
          key,
          Plug.Conn.get_session(conn, serialized_key(key, backend_config))
        )
      end)
    end

    @impl true
    def store_prefs!(conn, prefs, backend_config) do
      Enum.reduce(prefs, conn, fn {key, value}, conn ->
        Plug.Conn.put_session(
          conn,
          serialized_key(key, backend_config),
          value
        )
      end)
    end

    defp serialized_key(key, %{key_prefix: key_prefix}) do
      "#{key_prefix}#{key}"
    end
  end
end
