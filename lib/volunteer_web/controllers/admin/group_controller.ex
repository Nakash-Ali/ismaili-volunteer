defmodule VolunteerWeb.Admin.GroupController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Infrastructure
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  # Plugs

  plug :load_group when action not in [:index]
  plug :authorize,
    action_root: [:admin, :group],
    assigns_subject_key: :group
  plug :track,
    resource: "group",
    assigns_subject_key: :group

  def load_group(%Plug.Conn{params: %{"id" => id}} = conn, _opts) do
    Plug.Conn.assign(
      conn,
      :group,
      Infrastructure.get_group!(id)
    )
  end

  # Actions

  def index(conn, _params) do
    groups =
      Infrastructure.get_groups()
      |> Repo.preload(:region)

    render(conn, "index.html", groups: groups)
  end

  def show(%Plug.Conn{assigns: %{group: group}} = conn, _params) do
    group =
      Repo.preload(group, [region: :parent])

    render(conn, "show.html", group: group)
  end
end
