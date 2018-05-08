defmodule VolunteerWeb.Admin.TKNListingView do
  use VolunteerWeb, :view
  alias VolunteerWeb.FormView
  alias VolunteerWeb.Admin.CommonView
  alias VolunteerWeb.Admin.ListingView
  alias VolunteerWeb.Presenters.Title
  
  def render("head_extra.edit.html", %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
  
  def render("head_extra.new.html", %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
  
  def render("head_extra.none.html", %{conn: conn}) do
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
