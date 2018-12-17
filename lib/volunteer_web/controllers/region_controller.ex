defmodule VolunteerWeb.RegionController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Infrastructure
  alias Volunteer.Listings
  alias VolunteerWeb.ControllerUtils

  def show(conn, %{"title" => region_title} = params) do

  end

  def show(conn, %{"id" => region_id} = params) do
    region =
      Infrastructure.get_region!(region_id)
      |> Repo.preload([:parent])

    region_choices =
      Infrastructure.get_regions(filters: %{parent_id: region.id})

    region_in_path =
      Map.get(params, "region_in_path", true)
      |> ControllerUtils.booleanize

    listings =
      Listings.get_all_public_listings(filters: %{region_id: region.id, region_in_path: region_in_path})
      |> Repo.preload([:region, :group])

    {:ok, jumbotron_image_url} =
      Volunteer.Infrastructure.get_region_config(region.id, [:jumbotron, :image_url])

    {:ok, jumbotron_spanner_bg_color} =
      Volunteer.Infrastructure.get_region_config(region.id, [:jumbotron, :spanner_bg_color])

    {:ok, council_website_text} =
      Volunteer.Infrastructure.get_region_config(region.id, [:council_website, :text])

    {:ok, council_website_url} =
      Volunteer.Infrastructure.get_region_config(region.id, [:council_website, :url])

    render(
      conn,
      "show.html",
      region: region,
      region_choices: region_choices,
      region_in_path: region_in_path,
      listings: listings,
      jumbotron_image_url: jumbotron_image_url,
      jumbotron_spanner_bg_color: jumbotron_spanner_bg_color,
      council_website_text: council_website_text,
      council_website_url: council_website_url
    )
  end
end
