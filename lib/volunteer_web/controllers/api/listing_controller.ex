defmodule VolunteerWeb.API.ListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings

  def index(conn, _params) do
    listings =
      Listings.Public.get_all()
      |> Repo.preload([[region: :parent], [group: :region], :created_by, :organized_by, :public_approved_by])

    render(conn, "index.json", listings: listings)
  end
end
