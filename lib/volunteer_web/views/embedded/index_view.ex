defmodule VolunteerWeb.Embedded.IndexView do
  use VolunteerWeb, :view

  def render("head_extra.index.html", %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/index.css")
    ]
  end
end
