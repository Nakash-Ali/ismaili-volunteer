defmodule VolunteerWeb.Admin.IndexController do
  use VolunteerWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
