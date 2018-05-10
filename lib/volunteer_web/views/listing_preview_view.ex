defmodule VolunteerWeb.ListingPreviewView do
  use VolunteerWeb, :view
  alias VolunteerWeb.IndexView
  
  def render("head_extra.index.html", %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/index.css")
    ]
  end
end
