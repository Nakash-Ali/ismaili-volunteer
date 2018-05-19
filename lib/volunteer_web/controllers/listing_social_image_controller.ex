defmodule VolunteerWeb.ListingSocialImageController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  
  def show(conn, %{"listing_id" => id}) do
    listing = Apply.get_active_listing!(id) |> Repo.preload(Apply.Listing.preloadables())
    render(conn, "show.html", listing: listing)
  end
end
