defmodule VolunteerWeb.Admin.RegionController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Infrastructure
  alias Volunteer.Permissions
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
      |> Repo.preload([:parent, :children, :groups])
      |> annotate_config()
      |> annotate_roles_for_region()
      |> annotate_roles_for_region_groups()

    render(conn, "show.html", region: region)
  end

  defp annotate_config(region) do
    Map.put(
      region,
      :config,
      Infrastructure.get_region_config!(region.id)
    )
  end

  defp annotate_roles_for_region(region) do
    Permissions.annotate_roles_for_region(region)
  end

  defp annotate_roles_for_region_groups(region) do
    Map.update!(
      region,
      :groups,
      fn groups -> Enum.map(groups, &Permissions.annotate_roles_for_group/1) end
    )
  end
end
