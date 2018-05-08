defmodule VolunteerWeb.Navbar do
  import VolunteerWeb.Router.Helpers
  alias VolunteerWeb.Session
  
  @item_module VolunteerWeb.LayoutView
  @item_template "navbar_item.html"
  
  def nav_items(["VolunteerWeb", "Admin" | _ ], assigns) do
    admin_nav_items(assigns) ++ user_nav_items(assigns)
  end
  
  def nav_items(["VolunteerWeb" | _ ], assigns) do
    iicanada_nav_items() ++ user_nav_items(assigns)
  end
  
  def iicanada_nav_items do
    [
      {"IICanada", "https://iicanada.org"}
    ]
  end
  
  def user_nav_items(%{conn: conn}) do
    case Session.logged_in?(conn) do
      true ->
        [
          {VolunteerWeb.Presenters.Title.text(Session.get_user(conn)), nil},
          {"Logout", auth_path(conn, :logout)}
        ]
        
      false ->
        [
          {"Login", auth_path(conn, :login)}
        ]
    end 
  end
  
  def admin_nav_items(%{conn: conn}) do
    [
      {"Admin", admin_index_path(conn, :index)},
      {"Listings", admin_listing_path(conn, :index)},
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
      |> Map.merge(%{ item_text: item_text, item_href: item_href })
    Phoenix.View.render(@item_module, @item_template, all_assigns)
  end
  
  def get_view_module_path(%{view_module: view_module}) do
    Module.split(view_module)
  end
end
