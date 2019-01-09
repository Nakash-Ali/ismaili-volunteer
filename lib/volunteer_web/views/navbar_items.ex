defmodule VolunteerWeb.NavbarItems do
  alias VolunteerWeb.Router.Helpers, as: RouterHelpers
  alias VolunteerWeb.UserSession

  defmodule Item do
    defstruct text: nil, href: nil, children: nil, is_active?: false
  end

  defmodule Implementation do
    @item_module VolunteerWeb.LayoutView
    @item_template "navbar_item.html"

    def get_view_module_path(%{view_module: view_module}) do
      Module.split(view_module)
    end

    def identify_active(nav_items, %{conn: %{path_info: path_info}} = assigns) do
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

    def make_path_segments(nil) do
      []
    end

    def make_path_segments(uri) do
      uri
      |> URI.parse()
      |> Map.get(:path)
      |> String.trim("/")
      |> String.split("/")
    end

    def render_nav_item(%Item{} = item, assigns) do
      all_assigns = Map.merge(assigns, %{item: item})

      Phoenix.View.render(@item_module, @item_template, all_assigns)
    end
  end

  defmodule Config do
    defmodule Parent do
      def items do
        [
          %Item{
            text: Application.get_env(:volunteer, :global_parent_navbar_name),
            href: Application.get_env(:volunteer, :global_parent_navbar_url)
          }
        ]
      end
    end

    defmodule User do
      def items(%{conn: conn}) do
        case UserSession.logged_in?(conn) do
          true ->
            [
              %Item{
                text: VolunteerWeb.Presenters.Title.text(UserSession.get_user(conn)),
                href: nil
              },
              %Item{text: "Logout", href: RouterHelpers.auth_path(conn, :logout)}
            ]

          false ->
            [
              %Item{text: "Login", href: RouterHelpers.auth_path(conn, :login)}
            ]
        end
      end
    end

    defmodule Admin do
      def base(%{conn: conn}) do
        case UserSession.logged_in?(conn) do
          true ->
            [
              %Item{text: "Admin", href: RouterHelpers.admin_index_path(conn, :index)}
              # TODO: Enable documentation
              # {"Documentation", "https://drive.google.com/open?id=1Hvf9o_d5BPXYh0UJvvGO8GfAyCbia088"},
            ]

          false ->
            []
        end
      end

      def primary(%{conn: conn}) do
        conn
        |> VolunteerWeb.FeatureModules.configs_for_conn()
        |> Enum.map(fn conf ->
          %Item{text: conf.title, href: conf.path.(conn)}
        end)
      end
    end

    defmodule Feedback do
      def items(%{conn: conn}) do
        case UserSession.logged_in?(conn) do
          true ->
            [
              %Item{
                text: "Feedback",
                children: [
                  %Item{text: "Admin", href: RouterHelpers.admin_feedback_path(conn, :index, [])},
                  %Item{text: "Public", href: RouterHelpers.feedback_path(conn, :index, [])}
                ]
              }
            ]

          false ->
            [
              %Item{text: "Feedback", href: RouterHelpers.feedback_path(conn, :index, [])}
            ]
        end
      end
    end

    def for(["VolunteerWeb", "Admin" | _], assigns) do
      Admin.primary(assigns) ++
        Admin.base(assigns) ++ Feedback.items(assigns) ++ User.items(assigns)
    end

    def for(["VolunteerWeb" | _], assigns) do
      Admin.base(assigns) ++ Feedback.items(assigns) ++ User.items(assigns)
    end
  end

  def render(assigns) do
    Implementation.get_view_module_path(assigns)
    |> Config.for(assigns)
    |> Implementation.identify_active(assigns)
    |> Enum.map(&Implementation.render_nav_item(&1, assigns))
  end
end
