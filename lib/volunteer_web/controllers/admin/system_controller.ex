defmodule VolunteerWeb.Admin.SystemController do
  use VolunteerWeb, :controller

  @allowed_primary_emails [
    "alizain.feerasta@iicanada.net"
  ]

  plug :authorize_primary_email

  def authorize_primary_email(conn, _opts) do
    case VolunteerWeb.UserSession.get_user(conn) do
      %{primary_email: primary_email} when primary_email in @allowed_primary_emails ->
        conn

      _ ->
        raise VolunteerWeb.ConnPermissions.NotAllowedError
    end
  end

  def env(conn, _params) do
    render(
      conn,
      "data.html",
      data: System.get_env()
    )
  end

  def app(conn, _params) do
    render(
      conn,
      "data.html",
      data: :application.loaded_applications()
            |> Enum.map(fn {app, _description, _version} ->
              {app, :application.get_all_env(app)}
            end)
            |> Enum.into(%{})
    )
  end

  def endpoint(conn, _params) do
    render(
      conn,
      "data.html",
      data: :ets.tab2list(VolunteerWeb.Endpoint)
    )
  end
end
