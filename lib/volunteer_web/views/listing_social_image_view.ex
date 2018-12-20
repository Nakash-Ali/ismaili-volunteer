defmodule VolunteerWeb.ListingSocialImageView do
  alias VolunteerWeb.ListingView
  alias VolunteerWeb.Presenters.Title

  use VolunteerWeb, :view

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/social.css")
    ]
  end

  def render("analytics" <> _, _assigns) do
    []
  end
end
