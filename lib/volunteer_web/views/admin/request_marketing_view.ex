defmodule VolunteerWeb.Admin.RequestMarketingView do
  use VolunteerWeb, :view
  alias VolunteerWeb.FormView
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.Admin.ListingView
  alias VolunteerWeb.Presenters.Title
  
  def render("head_extra" <> _, %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
end
