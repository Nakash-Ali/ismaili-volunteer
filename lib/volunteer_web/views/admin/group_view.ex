defmodule VolunteerWeb.Admin.GroupView do
  use VolunteerWeb, :view
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.HTMLHelpers
  alias VolunteerWeb.Presenters.{Title, Temporal}

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def definition_list(:details, group, conn) do
    [
      {
        "Region",
        link(Title.html(group.region), to: RouterHelpers.admin_region_path(conn, :show, group.region))
      },
    ]
  end

  def definition_list(:roles, group) do
    [
      {
        "Admins",
        group.roles
        |> Enum.map(fn {email, role} -> link("#{email} (#{role})", to: "mailto:#{email}") end)
        |> HTMLHelpers.with_line_breaks()
      }
    ]
  end

  def definition_list(:meta, group) do
    [
      {
        "Creation date",
        Temporal.format_datetime(group.inserted_at)
      },
      {
        "Last updated date",
        Temporal.format_datetime(group.updated_at)
      },
    ]
  end
end
