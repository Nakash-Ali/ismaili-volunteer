defmodule VolunteerWeb.StaticHelpers do
  use Phoenix.HTML
  alias VolunteerWeb.Router.Helpers, as: RouterHelpers

  def script_tag(conn, path) do
    content_tag(:script, "", type: "text/javascript", src: RouterHelpers.static_path(conn, path))
  end

  def stylesheet_tag(conn, path) do
    tag(:link, rel: "stylesheet", href: RouterHelpers.static_path(conn, path))
  end
end
