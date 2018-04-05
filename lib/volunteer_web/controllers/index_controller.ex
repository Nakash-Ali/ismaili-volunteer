defmodule VolunteerWeb.IndexController do
  use VolunteerWeb, :controller
  alias Volunteer.Apply
  
  def index(conn, _params) do
    listings = Apply.get_approved_listings()
    render(conn, "index.html", listings: listings)
  end
end
