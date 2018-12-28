defmodule VolunteerWeb.HTMLMinifier do
  @semtex_config Semtex.config()
                 |> Map.put("escape_serialization", false)

  def init(opts \\ []), do: opts

  def call(conn, opts \\ [])

  if Mix.env() == :dev do
    def call(%Plug.Conn{params: %{"minify" => "false"}} = conn, _opts) do
      conn
    end
  end

  def call(%Plug.Conn{} = conn, _opts) do
    Plug.Conn.register_before_send(conn, &minify_body/1)
  end

  def minify_body(%Plug.Conn{} = conn) do
    case List.keyfind(conn.resp_headers, "content-type", 0) do
      {_, "text/html" <> _} ->
        body =
          conn.resp_body
          |> Semtex.Parser.parse!()
          |> Semtex.minify!(@semtex_config)
          |> Semtex.serialize!(@semtex_config)

        %Plug.Conn{conn | resp_body: body}

      _ ->
        conn
    end
  end
end
