defmodule VolunteerWeb.Admin.FeedbackView do
  use VolunteerWeb, :view
  alias VolunteerWeb.AdminView

  def render("head_extra" <> _, %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
end
