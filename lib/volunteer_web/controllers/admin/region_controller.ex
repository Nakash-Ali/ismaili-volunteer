defmodule VolunteerWeb.Admin.RegionController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Infrastructure
  alias VolunteerWeb.ConnPermissions

  # Plugs

  plug :authorize

  def authorize(conn, _opts) do
    ConnPermissions.ensure_allowed!(conn, [:admin, :region])
  end

  # Controller Actions

  def index(conn, _params) do
    regions =
      Infrastructure.get_regions()
      |> Repo.preload([:parent])

    render(conn, "index.html", regions: regions)
  end

  def show(conn, %{"id" => id}) do
    region =
      Infrastructure.get_region!(id)
      |> Repo.preload(Infrastructure.region_preloadables())
      |> Infrastructure.annotate([:hardcoded, :roles, {:groups, [:roles]}])

    render(conn, "show.html", region: region)
  end
end
