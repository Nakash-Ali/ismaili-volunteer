defmodule VolunteerWeb.FeatureModules do
  alias VolunteerWeb.Router.Helpers, as: RouterHelpers
  alias VolunteerWeb.ConnPermissions

  def configs() do
    [
      %{
        permission: [:admin, :listing],
        title: "Listings",
        description: "Create, edit, and manage volunteer opportunities.",
        path: fn conn -> RouterHelpers.admin_listing_path(conn, :index) end
      },
      %{
        permission: [:admin, :region],
        title: "Regions",
        description: "View config for regions",
        path: fn conn -> RouterHelpers.admin_region_path(conn, :index) end
      },
      %{
        permission: [:admin, :group],
        title: "Groups",
        description: "View config for groups",
        path: fn conn -> RouterHelpers.admin_group_path(conn, :index) end
      },
      %{
        permission: [:admin, :user],
        title: "Users",
        description: "View users in the system",
        path: fn conn -> RouterHelpers.admin_user_path(conn, :index) end
      },
    ]
  end

  def configs_for_conn(conn) do
    configs()
    |> Enum.filter(fn conf -> ConnPermissions.is_allowed?(conn, conf.permission) end)
  end
end