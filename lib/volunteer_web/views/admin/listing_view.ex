defmodule VolunteerWeb.Admin.ListingView do
  use VolunteerWeb, :view
  alias VolunteerWeb.FormView
  alias VolunteerWeb.VendorView
  alias VolunteerWeb.ListingView, as: PublicListingView
  alias VolunteerWeb.Admin.CommonView
  alias VolunteerWeb.Presenters.Title
  
  def render("head_extra.edit.html", %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
  
  def render("head_extra.index.html", %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
  
  def render("head_extra.new.html", %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
  
  def render("head_extra.show.html", %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
end
