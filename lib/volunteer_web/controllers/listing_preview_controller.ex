defmodule VolunteerWeb.ListingPreviewController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings

  def index(conn, %{"id" => id}) do
    listing =
      id
      |> Listings.get_one_preview_listing!()
      |> Repo.preload(Listings.Listing.preloadables())

    VolunteerWeb.Services.Analytics.track_event("Listing - Preview", "index", listing.id, conn)

    render(conn, VolunteerWeb.ListingPreviewView, "index.html", listings: [listing])
  end

  def show(conn, %{"id" => id}) do
    listing =
      id
      |> Listings.get_one_preview_listing!()
      |> Repo.preload(Listings.Listing.preloadables())

    VolunteerWeb.Services.Analytics.track_event("Listing - Preview", "show", listing.id, conn)

    render(conn, VolunteerWeb.ListingView, "show.html", listing: listing)
  end
end
