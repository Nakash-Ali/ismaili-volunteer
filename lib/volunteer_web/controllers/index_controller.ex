defmodule VolunteerWeb.IndexController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias Volunteer.Infrastructure

  def index(conn, _params) do
    region_choices = Infrastructure.get_regions()

    listings =
      Listings.get_all_public_listings()
      |> Repo.preload([:region, :group])

    render(
      conn,
      "index.html",
      listings: listings,
      region_choices: region_choices
    )
  end
end
