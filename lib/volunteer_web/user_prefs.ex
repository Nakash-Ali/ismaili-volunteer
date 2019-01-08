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

  def fetch_user_prefs(conn, fields) when is_map(fields) do
    fetch_user_prefs(conn, {fields, @default_backends})
  end

  def fetch_user_prefs(conn, {fields, backends}) when is_map(fields) and is_list(backends) do
    {conn, prefs} =
      Enum.reduce(backends, {conn, %{}}, fn {backend_module, backend_config}, {curr_conn, curr_prefs} ->
        new_prefs =
          backend_module.get_prefs!(curr_conn, keys(fields), backend_config)
          |> filter_and_normalize_prefs(fields)
          |> Map.merge(curr_prefs)

        new_conn =
          backend_module.store_prefs!(curr_conn, new_prefs, backend_config)

        {new_conn, new_prefs}
      end)

    final_prefs =
      Map.merge(
        default_prefs(fields),
        prefs
      )

    Plug.Conn.put_private(
      conn,
      @private_key,
      final_prefs
    )
  end

  defp keys(fields) do
    Map.keys(fields)
  end

  defp filter_and_normalize_prefs(raw_prefs, fields) do
    Enum.reduce(raw_prefs, %{}, fn
      {_key, nil}, curr_prefs ->
        curr_prefs

      {key, value}, curr_prefs ->
        case Map.fetch(fields, key) do
          {:ok, {type, _default}} ->
            case Ecto.Type.cast(type, value) do
              {:ok, normalized_value} ->
                curr_prefs |> Map.put(key, normalized_value)

              :error ->
                curr_prefs
            end

          {:ok, _} ->
            raise "Invalid field with key:#{key}"

          :error ->
            curr_prefs
        end

    end)
  end

  defp default_prefs(fields) do
    fields
    |> Enum.map(fn {key, {_type, default}} -> {key, default} end)
    |> Enum.into(%{})
  end

  defmodule Backend do
    @type conn :: Plug.Conn
    @type config :: map
    @type prefs :: map
    @type fields :: {atom, atom, any}
    @type keys :: [atom]

    @callback get_prefs!(conn, keys, config) :: prefs
    @callback store_prefs!(conn, prefs, config) :: conn

    defmodule Params do
      @behaviour VolunteerWeb.UserPrefs.Backend

      def get_prefs!(%{params: params}, keys, _config) do
        Enum.reduce(keys, %{}, fn atom_key, curr_prefs ->
          Map.put(
            curr_prefs,
            atom_key,
            Map.get(params, to_string(atom_key), nil)
          )
        end)
      end

      def store_prefs!(conn, _prefs, _config) do
        conn
      end
    end

    defmodule Session do
      @behaviour VolunteerWeb.UserPrefs.Backend

      def get_prefs!(conn, keys, config) do
        Enum.reduce(keys, %{}, fn atom_key, curr_prefs ->
          Map.put(
            curr_prefs,
            atom_key,
            Plug.Conn.get_session(conn, serialized_key(atom_key, config))
          )
        end)
      end

      def store_prefs!(conn, prefs, config) do
        Enum.reduce(prefs, conn, fn {atom_key, value}, conn ->
          Plug.Conn.put_session(
            conn,
            serialized_key(atom_key, config),
            value
          )
        end)
      end

      defp serialized_key(key, %{key_prefix: key_prefix}) do
        "#{key_prefix}#{key}"
      end
    end
  end
end
