defmodule VolunteerWeb.FeatureModules do
  alias VolunteerWeb.Router.Helpers
  alias VolunteerWeb.ConnPermissions

  def configs() do
    [
      %{
        permission: [:admin, :listing],
        title: "Listings",
        description: "Create, edit, and manage volunteer opportunities.",
        path: fn conn -> Helpers.admin_listing_path(conn, :index) end,
      },
      %{
        permission: [:admin, :user],
        title: "Users",
        description: "View users in the system",
        path: fn conn -> Helpers.admin_users_path(conn, :index) end,
      },
    ]
  end

  def configs_for_conn(conn) do
    configs()
    |> Enum.filter(fn conf -> ConnPermissions.is_allowed?(conn, conf.permission) end)
  end
end
