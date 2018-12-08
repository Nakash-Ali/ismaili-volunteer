defmodule VolunteerWeb.ListingSocialImageView do
  alias VolunteerWeb.ListingView
  alias VolunteerWeb.Presenters.Title

  use VolunteerWeb, :view

  def render("head_extra.show.html", %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/social.css")
    ]
  end

  def render("analytics.show.html", _assigns) do
    []
  end
end
