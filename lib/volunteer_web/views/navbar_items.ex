defmodule VolunteerWeb.NavbarItems do
  import VolunteerWeb.Router.Helpers
  alias VolunteerWeb.UserSession

  @item_module VolunteerWeb.LayoutView
  @item_template "navbar_item.html"

  def nav_items(["VolunteerWeb", "Admin" | _], assigns) do
    primary_admin_nav_item(assigns) ++ admin_nav_items(assigns) ++ user_nav_items(assigns)
  end

  def nav_items(["VolunteerWeb" | _], assigns) do
    iicanada_nav_items() ++ primary_admin_nav_item(assigns) ++ user_nav_items(assigns)
  end

  def iicanada_nav_items do
    [
      {"IICanada", "https://iicanada.org"}
    ]
  end

  def user_nav_items(%{conn: conn}) do
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

  def primary_admin_nav_item(%{conn: conn}) do
    case UserSession.logged_in?(conn) do
      true ->
        [
          {"Admin", admin_index_path(conn, :index)}
        ]

      false ->
        []
    end
  end

  def admin_nav_items(%{conn: conn}) do
    [
      {"Feeback", admin_feedback_path(conn, :index, [])}
    ]
  end

  def render(assigns) do
    get_view_module_path(assigns)
    |> nav_items(assigns)
    |> Enum.map(&render_nav_item(&1, assigns))
  end

  def render_nav_item({item_text, item_href}, assigns) do
    all_assigns =
      assigns
      |> Map.merge(%{item_text: item_text, item_href: item_href})

    Phoenix.View.render(@item_module, @item_template, all_assigns)
  end

  def get_view_module_path(%{view_module: view_module}) do
    Module.split(view_module)
  end
end
