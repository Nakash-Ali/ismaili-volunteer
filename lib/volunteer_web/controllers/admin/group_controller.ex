defmodule VolunteerWeb.Admin.GroupController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Infrastructure
  alias Volunteer.Permissions
  alias VolunteerWeb.ConnPermissions

  # Plugs

  plug :authorize

  def authorize(conn, _opts) do
    ConnPermissions.ensure_allowed!(conn, [:admin, :group])
  end

  # Controller Actions

  def index(conn, _params) do
    groups =
      Infrastructure.get_groups()

    render(conn, "index.html", groups: groups)
  end

  def show(conn, %{"id" => id}) do
    group =
      Infrastructure.get_group!(id)
      |> Repo.preload([region: :parent])
      |> annotate_roles_for_group()

    render(conn, "show.html", group: group)
  end

  defp annotate_roles_for_group(group) do
    Permissions.annotate_roles_for_group(group)
  end
end
