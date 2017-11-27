defmodule VolunteerWeb.IndexController do
  use VolunteerWeb, :controller

  def index(conn, _params) do
    json(conn, %{status: 200})
  end
end
