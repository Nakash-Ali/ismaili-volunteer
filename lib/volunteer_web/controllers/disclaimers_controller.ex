defmodule VolunteerWeb.DisclaimersController do
  use VolunteerWeb, :controller

  def privacy(conn, _params), do: render(conn, "privacy.html")
  def terms(conn, _params), do: render(conn, "terms.html")
end
