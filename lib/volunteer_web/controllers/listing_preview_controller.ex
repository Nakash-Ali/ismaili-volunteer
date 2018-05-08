defmodule VolunteerWeb.ListingPreviewController do
  use VolunteerWeb, :controller
  alias Volunteer.Apply

  def index(conn, %{"id" => id}) do
    listing =
      id
      |> Apply.get_preview_listing!
      |> Apply.preload_listing_all()
    render(conn, VolunteerWeb.IndexView, "opportunities.html", listings: [listing])
  end
  
  def show(conn, %{"id" => id}) do
    listing =
      id
      |> Apply.get_preview_listing!
      |> Apply.preload_listing_all()
    render(conn, VolunteerWeb.ListingView, "show.html", listing: listing)
  end
end
