defmodule VolunteerWeb.IndexView do
  use VolunteerWeb, :view
  alias VolunteerWeb.ListingView
  alias VolunteerWeb.Presenters.Title

  def render("head_extra.index.html", %{conn: conn}) do
    [
      {:safe, "<link href=\"https://fonts.googleapis.com/css?family=Spectral:300i\" rel=\"stylesheet\">"},
      StaticHelpers.stylesheet_tag(conn, "/css/index.css")
    ]
  end

  def listing_count_text(listings) do
    case length(listings) do
      0 -> "Found nothing"
      1 -> "Found 1 listing"
      len -> "Found #{len} listings"
    end
  end
end
