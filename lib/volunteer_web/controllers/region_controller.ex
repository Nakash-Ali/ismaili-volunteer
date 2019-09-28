defmodule VolunteerWeb.RegionController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Infrastructure
  alias Volunteer.Listings

  def show_by_slug(conn, %{"slug" => region_slug} = params) do
    case Infrastructure.get_region_by_slug(region_slug) do
      %Infrastructure.Region{} = region ->
        show(region, conn, params)

      _ ->
        raise VolunteerWeb.NoRouteErrorController.raise_error(conn)
    end
  end

  def show(conn, %{"id" => region_id} = params) do
    Infrastructure.get_region!(region_id) |> show(conn, params)
  end

  def show(%Infrastructure.Region{} = region, conn, params) do
    region =
      Repo.preload(region, [:parent])
      |> Infrastructure.annotate([:hardcoded])

    region_choices = Infrastructure.get_regions(filters: %{parent_id: region.id})

    region_in_path =
      Map.get(params, "region_in_path", true)
      |> VolunteerUtils.Controller.booleanize()

    listings =
      Listings.get_all_public_listings(filters: %{region_id: region.id, region_in_path: region_in_path})
      |> Repo.preload([:region, :group])

    render(
      conn,
      "show.html",
      region: region,
      region_choices: region_choices,
      region_in_path: region_in_path,
      listings: listings
    )
  end
end
