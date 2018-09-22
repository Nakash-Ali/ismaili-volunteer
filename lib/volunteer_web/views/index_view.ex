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

  def listing_count_text(listings) do
    case length(listings) do
      0 -> "Found nothing"
      1 -> "Found 1 listing"
      len -> "Found #{len} listings"
    end
  end
end
