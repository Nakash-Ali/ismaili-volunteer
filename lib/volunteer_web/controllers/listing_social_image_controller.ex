defmodule VolunteerWeb.ListingSocialImageController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  alias VolunteerWeb.Services.ListingSocialImageGenerator

  def show(conn, %{"id" => id}) do
    listing =
      Apply.get_one_public_listing!(id)
      |> Repo.preload(Apply.Listing.preloadables())

    render(conn, "show.html", listing: listing)
  end

  def image(conn, %{"id" => id}) do
    listing = Apply.get_one_public_listing!(id)
    disk_path = ListingSocialImageGenerator.get(conn, listing)

    conn
    |> put_resp_content_type("image/png", nil)
    |> send_file(200, disk_path)
  end
end
