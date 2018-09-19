defmodule VolunteerWeb.ListingSocialImageController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias VolunteerWeb.Services.ListingSocialImageGenerator

  def show(conn, %{"id" => id}) do
    listing =
      Listings.get_one_public_listing!(id)
      |> Repo.preload(Listings.Listing.preloadables())

    render(conn, "show.html", listing: listing)
  end

  def image(conn, %{"id" => id}) do
    listing = Listings.get_one_public_listing!(id)
    disk_path = ListingSocialImageGenerator.get(conn, listing)

    VolunteerWeb.Services.Analytics.track_event("Listing", "social_image_image", Slugify.slugify(listing), conn)

    conn
    |> put_resp_content_type("image/png", nil)
    |> send_file(200, disk_path)
  end
end
