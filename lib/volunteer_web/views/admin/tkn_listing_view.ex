defmodule VolunteerWeb.Admin.TKNListingView do
  use VolunteerWeb, :view
  alias VolunteerWeb.FormView
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.Admin.ListingView

  def render("head_extra" <> page, %{conn: conn}) when page in [".edit.html", ".new.html"] do
    [
      # render(VolunteerWeb.VendorView, "choices.html"),
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css"),
    ]
  end

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def render("body_extra" <> page, %{conn: conn}) when page in [".edit.html", ".new.html"] do
    [
      render(VolunteerWeb.VendorView, "datepicker.html"),
    ]
  end
end
