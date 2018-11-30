defmodule VolunteerWeb.RegionView do
  use VolunteerWeb, :view
  alias VolunteerWeb.Presenters.Title

  def render("head_extra.show.html", %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/region.css")
    ]
  end
end
