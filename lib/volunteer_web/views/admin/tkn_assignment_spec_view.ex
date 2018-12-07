defmodule VolunteerWeb.Admin.TKNAssignmentSpecView do
  use VolunteerWeb, :view
  alias VolunteerWeb.Presenters.Title
  alias VolunteerWeb.ListingView

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css"),
      StaticHelpers.stylesheet_tag(conn, "/css/tkn-assignment-spec.css")
    ]
  end

  def not_available do
    "-"
  end

  def not_available?(value) when value in ["", nil] do
    not_available()
  end

  def not_available?(value) do
    value
  end
end
