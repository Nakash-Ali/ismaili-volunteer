defmodule VolunteerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :volunteer
  use Sentry.Phoenix.Endpoint
  use Appsignal.Phoenix

  socket "/socket", VolunteerWeb.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: Application.get_env(:volunteer, VolunteerWeb.Endpoint) |> Keyword.fetch!(:static_at),
    from: :volunteer,
    gzip: false,
    only: ~w(css fonts images js doctemplates favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_volunteer_key",
    signing_salt: "HzvjaIsIREkCKRE2bBdgIhA7JF3CO0cHviIyGUow",
    encryption_salt: "LJanZXeGKBqNzPfzaUSTFuyBJQNJZqhpjC0XgoYT"

  plug VolunteerWeb.Router

  @doc """
  Callback invoked for dynamically configuring the endpoint.

  It receives the endpoint configuration and checks if
  configuration should be loaded from the system environment.
  """
  def init(_key, config) do
    {:ok, config}
  end

  def static_at do
    Application.get_env(:volunteer, VolunteerWeb.Endpoint) |> Keyword.fetch!(:static_at)
  end

  def static_dir(path) when is_binary(path) do
    static_dir([path])
  end

  def static_dir(path) when is_list(path) do
    Path.join([:code.priv_dir(:volunteer), static_at()] ++ path)
  end
end
