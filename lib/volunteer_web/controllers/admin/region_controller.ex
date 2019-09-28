defmodule VolunteerWeb.Admin.RegionController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Infrastructure
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]

  # Plugs

  plug :load_region when action not in [:index]
  plug :authorize,
    action_root: [:admin, :region],
    assigns_subject_key: :region

  def load_region(%Plug.Conn{params: %{"id" => id}} = conn, _opts) do
    Plug.Conn.assign(
      conn,
      :region,
      Infrastructure.get_region!(id)
    )
  end

  # Actions

  def index(conn, _params) do
    regions =
      Infrastructure.get_regions()
      |> Repo.preload([:parent])

    render(conn, "index.html", regions: regions)
  end

  def show(%Plug.Conn{assigns: %{region: region}} = conn, _params) do
    region =
      region
      |> Repo.preload(Infrastructure.region_preloadables())
      |> Infrastructure.annotate([:hardcoded])

    render(conn, "show.html", region: region)
  end
end
