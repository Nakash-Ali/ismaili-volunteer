defmodule VolunteerWeb.Admin.Listing.PublicView do
  use VolunteerWeb, :view
  alias Volunteer.Listings.Public
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.Admin.ListingView
  alias VolunteerWeb.WorkflowView

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
end
