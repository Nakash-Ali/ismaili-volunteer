defmodule VolunteerWeb.Admin.IndexController do
  use VolunteerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
