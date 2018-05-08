defmodule VolunteerWeb.Admin.IndexView do
  use VolunteerWeb, :view
  alias VolunteerWeb.Admin.CommonView
  
  def render("head_extra.index.html", %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
end
