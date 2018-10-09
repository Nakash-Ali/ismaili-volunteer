defmodule VolunteerWeb.NavbarItems do
  import VolunteerWeb.Router.Helpers
  alias VolunteerWeb.UserSession

  @item_module VolunteerWeb.LayoutView
  @item_template "navbar_item.html"

  defmodule ItemsConfig do
    defmodule IICanada do
      def items do
        [
          {"IICanada", "https://iicanada.org"}
        ]
      end
    end

    defmodule User do
      def items(%{conn: conn}) do
        case UserSession.logged_in?(conn) do
          true ->
            [
              {VolunteerWeb.Presenters.Title.text(UserSession.get_user(conn)), nil},
              {"Logout", auth_path(conn, :logout)}
            ]

          false ->
            [
              {"Login", auth_path(conn, :login)}
            ]
        end
      end
    end

    defmodule Admin do
      def base(%{conn: conn}) do
        case UserSession.logged_in?(conn) do
          true ->
            [
              {"Admin", admin_index_path(conn, :index)},
              {"Documentation", "https://drive.google.com/open?id=1Hvf9o_d5BPXYh0UJvvGO8GfAyCbia088"},
            ]

          false ->
            []
        end
      end

      def primary(%{conn: conn}) do
        features_nav_items =
          conn
          |> VolunteerWeb.FeatureModules.configs_for_conn()
          |> Enum.map(fn conf ->
            {conf.title, conf.path.(conn)}
          end)

        extra_nav_items = [
          {"Feedback", admin_feedback_path(conn, :index, [])},
        ]

        features_nav_items ++ extra_nav_items
      end
    end

    def for(["VolunteerWeb", "Admin" | _], assigns) do
      Admin.primary(assigns) ++ Admin.base(assigns) ++ User.items(assigns)
    end

    def for(["VolunteerWeb" | _], assigns) do
      Admin.base(assigns) ++ User.items(assigns)
    end
  end

  def render(assigns) do
    get_view_module_path(assigns)
    |> ItemsConfig.for(assigns)
    |> identify_active(assigns)
    |> Enum.map(&render_nav_item(&1, assigns))
  end

  def get_view_module_path(%{view_module: view_module}) do
    Module.split(view_module)
  end

  def identify_active(nav_items, %{conn: %{path_info: path_info}}) do
    nav_items
    |> Enum.with_index()
    |> Enum.map(fn {{_item_text, item_href} = nav_item, index} ->
      segments =
        make_path_segments(item_href)
      %{
        index: index,
        length: length(segments),
        segments: segments,
        nav_item: nav_item,
      }
    end)
    |> Enum.sort_by(&(&1.length), &>=/2)
    |> Enum.map_reduce(false, fn
      data = %{nav_item: {item_text, item_href}}, true ->
        {%{data | nav_item: {item_text, item_href, false}}, true}
      data = %{segments: [], nav_item: {item_text, item_href}}, _found_active? ->
        {%{data | nav_item: {item_text, item_href, false}}, false}
      data = %{segments: segments, nav_item: {item_text, item_href}}, _found_active? ->
        item_active? =
          List.starts_with?(path_info, segments)
        {%{data | nav_item: {item_text, item_href, item_active?}}, item_active?}
    end)
    |> elem(0)
    |> Enum.sort_by(&(&1.index), &<=/2)
    |> Enum.map(&(&1.nav_item))
  end

  def make_path_segments(nil)  do
    []
  end

  def make_path_segments(uri)  do
    uri
    |> URI.parse()
    |> Map.get(:path)
    |> String.trim("/")
    |> String.split("/")
  end

  def render_nav_item({item_text, item_href, item_active?}, assigns) do
    all_assigns =
      assigns
      |> Map.merge(%{item_text: item_text, item_href: item_href, item_active?: item_active?})

    Phoenix.View.render(@item_module, @item_template, all_assigns)
  end
end
