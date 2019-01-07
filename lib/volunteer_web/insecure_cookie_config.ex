defmodule VolunteerWeb.InsecureCookieConfig do
  @config %{
    root_assigns_key: :cookie_config,
    cookie: %{
      # domain: "ots.the.ismaili",
      prefix: "_volunteer_config",
      http_only: true,
      secure: Mix.env() == :prod
    }
  }
  @cookie_opts Keyword.new(@config[:cookie])

  def init(opts) do
    opts
    |> Enum.into(%{})
  end

  def call(conn, opts) do
    synchronize(conn, opts)
  end

  def synchronize(conn, opts) do
    with {:ok, value} <- get_from_params(conn, opts),
         {:ok, updated_value} <- normalize_value(opts, value) do
      conn
      |> put_in_cookie!(opts, updated_value)
      |> put_in_assigns!(opts, updated_value)
    else
      _ ->
        conn
        |> put_in_assigns!(
          opts,
          get_from_cookie!(conn, opts)
        )
    end
  end

  defp cookie_key(%{key: key}) when is_atom(key) do
    @config.cookie.prefix <> "_" <> Atom.to_string(key)
  end

  defp params_key(%{key: key}) when is_atom(key) do
    Atom.to_string(key)
  end

  defp assigns_key(%{key: key}) when is_atom(key) do
    key
  end

  defp serialize_to_cookie(value) when is_binary(value) do
    Base.encode64(value, padding: false)
  end

  defp serialize_to_cookie(value) when not is_binary(value) do
    value |> to_string() |> serialize_to_cookie()
  end

  defp deserialize_from_cookie(value) do
    Base.decode64(value, padding: false)
  end

  defp get_from_params(conn, opts) do
    conn
    |> Map.get(:params, %{})
    |> Map.fetch(params_key(opts))
  end

  defp normalize_value(%{type: type}, value) do
    Ecto.Type.cast(type, value)
  end

  defp put_in_assigns!(conn, opts, value) do
    updated_assigns =
      conn
      |> Map.fetch!(:assigns)
      |> Map.get(@config.root_assigns_key, %{})
      |> Map.put(assigns_key(opts), value)

    Plug.Conn.assign(conn, @config.root_assigns_key, updated_assigns)
  end

  defp put_in_cookie!(conn, opts, value) do
    Plug.Conn.put_resp_cookie(
      conn,
      cookie_key(opts),
      serialize_to_cookie(value),
      @cookie_opts
    )
  end

  defp get_from_cookie!(conn, %{default: default_value} = opts) do
    with {:ok, raw_value} <- Map.fetch(conn.cookies, cookie_key(opts)),
         {:ok, value} <- deserialize_from_cookie(raw_value),
         {:ok, updated_value} <- normalize_value(opts, value) do
      updated_value
    else
      _ ->
        default_value
    end
  end
end
