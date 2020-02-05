defmodule VolunteerWeb.GroupController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Infrastructure
  alias Volunteer.Listings
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  # Plugs

  plug :load_group
  plug :track,
    resource: "group",
    assigns_subject_key: :group

  def load_group(%Plug.Conn{params: %{"id" => id}} = conn, _opts) do
    group =
      Infrastructure.get_group!(id)
      |> Repo.preload(:region)

    Plug.Conn.assign(conn, :group, group)
  end

  # Actions

  # TODO: allow users to filter by groups on the OTS homepage

  def show(%Plug.Conn{assigns: %{group: group}} = conn, _params) do
    {:ok, jumbotron_image_url} =
      Volunteer.Infrastructure.get_region_config(group.region_id, [:jumbotron, :image_url])

    listings =
      Listings.Public.get_all(filters: %{group_id: group.id})
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
