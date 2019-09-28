defmodule VolunteerWeb.Admin.TKNListingView do
  use VolunteerWeb, :view
  alias VolunteerWeb.FormView
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.Admin.ListingView

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def render("body_extra" <> page, _) when page in [".edit.html", ".new.html"] do
    [
      render(VolunteerWeb.VendorView, "datepicker.html"),
    ]
  end

  def eoa_evaluation_label(true) do
    "Yes, required"
  end

  def eoa_evaluation_label(false) do
    "No, not necessary"
  end
end
