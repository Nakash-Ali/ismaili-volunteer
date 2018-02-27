defmodule VolunteerWeb.Admin.IndexController do
  use VolunteerWeb, :controller

  def index(conn, _params) do
    text conn, "soemthing's happening in the admin section"
  end
end
