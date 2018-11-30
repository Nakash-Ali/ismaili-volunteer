defmodule VolunteerWeb.Legacy.ApplyView do
  use VolunteerWeb, :view

  def render("body_extra.error.html", %{conn: conn}) do
    [
      StaticHelpers.script_tag(conn, "/js/error.js")
    ]
  end
end
