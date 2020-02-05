defmodule VolunteerWeb.Listing.SocialImageController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias VolunteerWeb.Services.SaveWebpage
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  # Plugs

  plug :load_listing
  plug :track,
    resource: "listing",
    assigns_subject_key: :listing

  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing =
      id
      |> Listings.Public.get_one!(allow_expired: true)
      |> Repo.preload(Listings.preloadables())

    Plug.Conn.assign(conn, :listing, listing)
  end

  # Actions

  def show(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    conn
    |> put_layout({VolunteerWeb.LayoutView, "app_bare.html"})
    |> render(
      "show.html",
      listing: listing
    )
  end

  def png(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    redirect(
      conn,
      external: SaveWebpage.listing_social_image!(:sync, conn, listing)
    )
  end
end
