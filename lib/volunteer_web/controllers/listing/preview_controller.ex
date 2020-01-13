defmodule VolunteerWeb.Listing.PreviewController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  # Plugs

  plug :load_listing
  plug :track,
    resource: "listing",
    assigns_subject_key: :listing

  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing =
      id
      |> Listings.Public.get_one_for_preview!()
      |> Repo.preload(Listings.preloadables())

    Plug.Conn.assign(conn, :listing, listing)
  end

  # Actions

  def index(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    render(conn, VolunteerWeb.Listing.PreviewView, "index.html", listings: [listing])
  end

  def show(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    render(conn, VolunteerWeb.ListingView, "show.html", listing: listing)
  end
end
