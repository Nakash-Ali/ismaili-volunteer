defmodule VolunteerWeb.Legacy.ApplyView do
  use VolunteerWeb, :view
  
  def page_title(%{view_template: "error.html"}) do
    "Error"
  end
  
  def page_title(%{view_template: "thank_you.html"}) do
    "Thank you!"
  end
  
  def render("body_extra.error.html", %{conn: conn}) do
    [
      script_tag(conn, "/js/error.js")
    ]
  end
end
