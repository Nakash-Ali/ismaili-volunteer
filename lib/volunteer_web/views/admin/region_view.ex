defmodule VolunteerWeb.Admin.RegionView do
  use VolunteerWeb, :view
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.HTMLHelpers
  alias VolunteerWeb.Presenters.{Title, Temporal}

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def definition_list(:hierarchy, region, conn) do
    [
      {
        "Parent region",
        if region.parent do
          link(Title.html(region.parent), to: RouterHelpers.admin_region_path(conn, :show, region.parent))
        else
          nil
        end
      },
      {
        "Child regions",
        region.children
        |> Enum.map(&link(Title.html(&1), to: RouterHelpers.admin_region_path(conn, :show, &1)))
        |> HTMLHelpers.with_line_breaks()
      },
    ]
  end

  def definition_list(:groups, region, conn) do
    [
      {
        "Groups",
        region.groups
        |> Enum.map(&link(Title.html(&1), to: RouterHelpers.admin_group_path(conn, :show, &1)))
        |> HTMLHelpers.with_line_breaks()
      }
    ]
  end

  def definition_list(:jamatkhanas, region) do
    [
      {
        "Jamatkhanas",
        region.hardcoded.jamatkhanas |> Enum.sort() |> HTMLHelpers.with_line_breaks()
      }
    ]
  end

  def definition_list(:roles, region) do
    [
      {
        "Admins",
        region.roles
        |> Enum.map(fn {email, role} -> link("#{email} (#{role})", to: "mailto:#{email}") end)
        |> HTMLHelpers.with_line_breaks()
      }
    ]
  end

  def definition_list(:links, region) do
    [
      {
        "OTS website",
        region.hardcoded.ots_website |> HTMLHelpers.external_link()
      },
      {
        "System email name",
        region.hardcoded.system_email |> elem(0)
      },
      {
        "System email address",
        region.hardcoded.system_email |> elem(1) |> HTMLHelpers.external_link(:mailto)
      },
      {
        "Council website text",
        region.hardcoded.council_website.text
      },
      {
        "Council website link",
        region.hardcoded.council_website.url |> HTMLHelpers.external_link()
      },
    ]
  end


  def definition_list(:tkn, region) do
    [
      {
        "TKN country",
        region.hardcoded.tkn.country
      },
      {
        "TKN coordinator name",
        region.hardcoded.tkn.coordinator.name
      },
      {
        "TKN coordinator title",
        region.hardcoded.tkn.coordinator.title
      },
      {
        "TKN coordinator email",
        region.hardcoded.tkn.coordinator.email |> HTMLHelpers.external_link(:mailto)
      },
      {
        "TKN coordinator phone",
        region.hardcoded.tkn.coordinator.phone |> HTMLHelpers.external_link(:tel)
      },
    ]
  end

  def definition_list(:marketing, region) do
    [
      {
        "Marketing channels",
        region.hardcoded.marketing_request.channels |> Map.keys() |> HTMLHelpers.with_line_breaks()
      },
      {
        "Marketing request email",
        region.hardcoded.marketing_request.email |> Enum.map(&HTMLHelpers.external_link(&1, :mailto)) |> HTMLHelpers.with_line_breaks()
      }
    ]
  end

  def definition_list(:meta, region) do
    [
      {
        "Creation date",
        Temporal.format_datetime(region.inserted_at)
      },
      {
        "Last updated date",
        Temporal.format_datetime(region.updated_at)
      },
    ]
  end
end