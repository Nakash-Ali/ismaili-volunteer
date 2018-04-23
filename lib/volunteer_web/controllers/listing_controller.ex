defmodule VolunteerWeb.ListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Apply

  def show(conn, %{"id" => id}) do
    listing = Apply.get_listing_if_approved!(id) |> Apply.preload_listing_all()
    render(conn, "show.html", listing: listing)
  end
end
