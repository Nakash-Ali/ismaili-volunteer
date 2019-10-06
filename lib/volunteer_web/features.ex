defmodule VolunteerWeb.Features do
  alias VolunteerWeb.Router.Helpers, as: RouterHelpers
  alias VolunteerWeb.ConnPermissions
  alias VolunteerWeb.UserSession

  defmodule Item do
    defstruct title: nil,
              description: nil,
              children: nil,
              href: nil,
              external: false,
              is_active?: false,
              is_allowed?: true
  end

  def generate(type, assigns) do
    items(type, assigns)
    |> Enum.filter(fn conf -> conf.is_allowed? end)
  end

  def generate_and_identify(type, assigns) do
    generate(type, assigns)
    |> identify_active(assigns)
  end

  defp items(id, assigns)

  defp items(:navbar, assigns) do
    generate(:admin_navbar, assigns) ++ generate(:feedback_navbar, assigns) ++ generate(:user_navbar, assigns)
  end

  defp items(:user_navbar, %{conn: conn}) do
    if UserSession.logged_in?(conn) do
      [
        %Item{
          title: VolunteerWeb.Presenters.Title.plain(UserSession.get_user(conn)),
          href: nil
        },
        %Item{
          title: "Logout",
          href: RouterHelpers.auth_path(conn, :logout)
        },
      ]
    else
      [
        %Item{
          title: "Login",
          href: RouterHelpers.auth_path(conn, :login)
        },
      ]
    end
  end

  defp items(:feedback_navbar, %{conn: conn}) do
    if UserSession.logged_in?(conn) do
      [
        %Item{
          title: "Feedback",
          children: [
            %Item{
              title: "Admin",
              href: RouterHelpers.admin_feedback_path(conn, :index, [])
            },
            %Item{
              title: "Public",
              href: RouterHelpers.feedback_path(conn, :index, [])
            }
          ]
        }
      ]
    else
      [
        %Item{
          title: "Feedback",
          href: RouterHelpers.feedback_path(conn, :index, [])
        }
      ]
    end
  end

  defp items(:admin_navbar, %{conn: conn} = assigns) do
    if UserSession.logged_in?(conn) do
      [
        %Item{
          title: "Admin",
          children: generate(:admin_home, assigns) ++ generate(:admin_primary, assigns)
        },
        # TODO: re-enable once docs have been reviewed
        # %Item{
        #   title: "Docs",
        #   children: generate(:admin_docs, assigns)
        # },
      ]
    else
      []
    end
  end

  defp items(:admin_home, %{conn: conn}) do
    [
      %Item{
        title: "Home",
        href: RouterHelpers.admin_index_path(conn, :index)
      }
    ]
  end

  defp items(:admin_docs, _assigns) do
    [
      %Item{
        title: "Handbook",
        href: "https://docs.google.com/document/d/1NppvEe5pxM7YEn0kvsR4Vw2IPUyffaczPrkzFDSLv0k/edit?usp=sharing",
        external: true,
      }
    ]
  end

  defp items(:admin_primary, %{conn: conn}) do
    [
      %Item{
        title: "Listings",
        description: "Create, edit, and manage volunteer opportunities.",
        href: RouterHelpers.admin_listing_path(conn, :index),
        is_allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :index]),
      },
      %Item{
        title: "Regions",
        description: "View config for regions",
        href: RouterHelpers.admin_region_path(conn, :index),
        is_allowed?: ConnPermissions.is_allowed?(conn, [:admin, :region, :index]),
      },
      %Item{
        title: "Groups",
        description: "View config for groups",
        href: RouterHelpers.admin_group_path(conn, :index),
        is_allowed?: ConnPermissions.is_allowed?(conn, [:admin, :group, :index]),
      },
      %Item{
        title: "Users",
        description: "View users in the system",
        href: RouterHelpers.admin_user_path(conn, :index),
        is_allowed?: ConnPermissions.is_allowed?(conn, [:admin, :user, :index]),
      },
    ]
  end

  defp items(:region_subtitle, %{conn: conn, region: region}) do
    [
      %Item{
        title: "Info",
        href: RouterHelpers.admin_region_path(conn, :show, region),
      },
      %Item{
        title: "Roles",
        href: RouterHelpers.admin_region_role_path(conn, :index, region),
      },
    ]
  end

  defp items(:group_subtitle, %{conn: conn, group: group}) do
    [
      %Item{
        title: "Info",
        href: RouterHelpers.admin_group_path(conn, :show, group),
      },
      %Item{
        title: "Roles",
        href: RouterHelpers.admin_group_role_path(conn, :index, group),
      },
    ]
  end

  defp items(:listing_subtitle, %{conn: conn, listing: listing}) do
    [
      %Item{
        title: "Info",
        href: RouterHelpers.admin_listing_path(conn, :show, listing),
        is_allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :show], listing),
      },
      %Item{
        title: "Roles",
        href: RouterHelpers.admin_listing_role_path(conn, :index, listing),
        is_allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :role, :index], listing),
      },
      %Item{
        title: "Applicants",
        href: RouterHelpers.admin_listing_applicant_path(conn, :index, listing),
        is_allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :applicant, :index], listing),
      },
      %Item{
        title: "TKN",
        href: RouterHelpers.admin_listing_tkn_listing_path(conn, :show, listing),
        is_allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :tkn_listing, :show], listing),
      },
      %Item{
        title: "Marketing",
        href: RouterHelpers.admin_listing_marketing_request_path(conn, :show, listing),
        is_allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :marketing_request, :show], listing),
      },
    ]
  end

  defp identify_active(nav_items, %{conn: %{path_info: path_info}} = assigns) do
    nav_items
    |> Enum.with_index()
    |> Enum.map(fn
      {%Item{href: item_href, children: nil} = nav_item, index} ->
        segments = make_path_segments(item_href)

        %{
          index: index,
          length: length(segments),
          segments: segments,
          nav_item: nav_item
        }

      {%Item{children: child_nav_items} = nav_item, index} when is_list(child_nav_items) ->
        %{
          index: index,
          length: nil,
          segments: nil,
          nav_item: Map.update!(nav_item, :children, &identify_active(&1, assigns))
        }
    end)
    |> Enum.sort_by(& &1.length, &>=/2)
    |> Enum.map_reduce(false, fn
      data, true ->
        {data, true}

      data = %{nav_item: %{children: child_nav_items}}, _found_active? when is_list(child_nav_items) ->
        item_active? =
          child_nav_items
          |> Enum.map(& &1.is_active?)
          |> Enum.any?()

        {put_in(data, [:nav_item, Access.key!(:is_active?)], item_active?), item_active?}

      data = %{segments: []}, _found_active? ->
        {data, false}

      data = %{segments: segments}, _found_active? ->
        item_active? = List.starts_with?(path_info, segments)

        {put_in(data, [:nav_item, Access.key!(:is_active?)], item_active?), item_active?}
    end)
    |> elem(0)
    |> Enum.sort_by(& &1.index, &<=/2)
    |> Enum.map(& &1.nav_item)
  end

  defp make_path_segments(nil) do
    []
  end

  defp make_path_segments(uri) do
    uri
    |> URI.parse()
    |> Map.get(:path)
    |> String.trim("/")
    |> String.split("/")
  end
end
