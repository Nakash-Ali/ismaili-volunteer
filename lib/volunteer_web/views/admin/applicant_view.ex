defmodule VolunteerWeb.Admin.ApplicantView do
  use VolunteerWeb, :view
  alias VolunteerWeb.Admin.ListingView

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
end
