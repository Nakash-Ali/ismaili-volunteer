defmodule VolunteerWeb.ListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply

  def show(conn, %{"id" => id}) do
    listing = Apply.get_one_public_listing!(id) |> Repo.preload(Apply.Listing.preloadables())
    render(conn, "show.html", listing: listing)
  end
end
