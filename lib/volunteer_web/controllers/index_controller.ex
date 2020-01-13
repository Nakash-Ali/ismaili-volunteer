defmodule VolunteerWeb.IndexController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias Volunteer.Infrastructure
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  plug :track,
    resource: "index"

  def index(conn, _params) do
    region_choices = Infrastructure.get_regions()

    listings =
      Listings.Public.get_all()
      |> Repo.preload([:region, :group])

    render(
      conn,
      "index.html",
      listings: listings,
      region_choices: region_choices
    )
  end
end
