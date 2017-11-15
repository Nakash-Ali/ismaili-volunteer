defmodule VolunteerWeb.LegacyController do
  use VolunteerWeb, :controller

  def apply(conn, params) do
    json(conn, params)
  end
end
