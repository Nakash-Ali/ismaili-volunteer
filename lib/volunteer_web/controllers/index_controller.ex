defmodule VolunteerWeb.IndexController do
  use VolunteerWeb, :controller
  alias Volunteer.Listings

  def index(conn, _params) do
    listings = Listings.get_all_public_listings()
    render(conn, "index.html", listings: listings)
  end
end
