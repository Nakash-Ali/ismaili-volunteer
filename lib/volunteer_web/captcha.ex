defmodule VolunteerWeb.Captcha do
  def init(opts \\ %{}) do
    opts
  end

  def call(%Plug.Conn{params: params} = conn, opts) do
    case Recaptcha.verify(params["g-recaptcha-response"]) do
      {:ok, _} ->
        conn

      {:error, reasons} ->
        IO.inspect(reasons)

        handle_deny(conn, opts)
    end
  end

  def handle_deny(conn, opts = %{handle_deny: handle_deny_func}) do
    module = Phoenix.Controller.controller_module(conn)
    apply(module, handle_deny_func, [conn, opts])
  end
end
