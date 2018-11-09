defmodule VolunteerWeb.Embedded.IndexController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings

  def index(conn, _params) do
    listings =
      Listings.get_all_public_listings()
      |> Repo.preload([:region, :group])

    render(
      conn,
      "index.html",
      listings: listings
    )
  end
end
