defmodule VolunteerWeb.IndexView do
  use VolunteerWeb, :view
  alias VolunteerWeb.LayoutView
  alias VolunteerWeb.ListingView
  alias VolunteerWeb.Presenters.Title

  def render("head_extra.index.html", %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/index.css")
    ]
  end

  def render("body_header.index.html", _assigns) do
    []
  end

  def render("body_extra.index.html", %{conn: conn}) do
    [
      script_tag(conn, "/js/smooth.js")
    ]
  end
end
