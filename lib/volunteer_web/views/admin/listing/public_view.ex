defmodule VolunteerWeb.Admin.Listing.PublicView do
  use VolunteerWeb, :view

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
end
