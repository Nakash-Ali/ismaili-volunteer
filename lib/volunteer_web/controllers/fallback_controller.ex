defmodule VolunteerWeb.FallbackController do
  use Phoenix.Controller, namespace: VolunteerWeb
  import Plug.Conn

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(VolunteerWeb.ErrorView, :"404")
    |> halt
  end
end
