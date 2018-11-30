defmodule VolunteerWeb.Admin.FeedbackView do
  use VolunteerWeb, :view
  alias VolunteerWeb.AdminView

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def render("body_footer" <> _, _assigns) do
    []
  end
end
