defmodule VolunteerWeb.GroupController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Infrastructure
  alias Volunteer.Listings

  # TODO: allow users to filter by groups on the OTS homepage

  def show(conn, %{"id" => group_id}) do
    group =
      Infrastructure.get_group!(group_id)
      |> Repo.preload(:region)

    {:ok, jumbotron_image_url} =
      Volunteer.Infrastructure.get_region_config(group.region_id, [:jumbotron, :image_url])

    listings =
      Listings.get_all_public_listings(filters: %{group_id: group.id})
      |> Repo.preload([:region, :group])

    render(
      conn,
      "show.html",
      group: group,
      listings: listings,
      jumbotron_image_url: jumbotron_image_url
    )
  end
end
