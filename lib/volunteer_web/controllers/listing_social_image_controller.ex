defmodule VolunteerWeb.ListingSocialImageController do
  use VolunteerWeb, :controller
  alias Volunteer.Apply

  def show(conn, %{"listing_id" => id}) do
    listing = Apply.get_active_listing!(id) |> Apply.preload_listing_all()
    render(conn, "show.html", listing: listing)
  end
end
