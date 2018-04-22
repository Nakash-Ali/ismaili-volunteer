defmodule VolunteerWeb.StaticHelpers do
  use Phoenix.HTML
  alias VolunteerWeb.Router.Helpers

  def script_tag(conn, path) do
    tag(:script, type: "text/javascript", src: Helpers.static_path(conn, path))
  end
  
  def stylesheet_tag(conn, path) do
    tag(:link, rel: "stylesheet", href: Helpers.static_path(conn, path))
  end
end
