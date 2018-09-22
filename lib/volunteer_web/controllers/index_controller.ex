defmodule VolunteerWeb.IndexController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias Volunteer.Infrastructure
  alias VolunteerWeb.IndexParams
  alias VolunteerWeb.ControllerUtils

  def index(conn, params) do
    region_id_choices =
      Infrastructure.get_region_id_choices()

    {filter_changes, filter_data} =
      IndexParams.IndexFilters.changes_and_data(params["filters"], region_id_choices)

    listings =
      Listings.get_all_public_listings(filters: filter_data)
      |> Repo.preload([:region, :group])

    render(
      conn,
      "index.html",
      listings: listings,
      filters: filter_changes,
      filters_active?: params["filters"] != nil,
      region_id_choices: ControllerUtils.blank_select_choice() ++ region_id_choices
    )
  end
end
