defmodule VolunteerWeb.Admin.IndexView do
  use VolunteerWeb, :view
  alias VolunteerWeb.AdminView

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
end
