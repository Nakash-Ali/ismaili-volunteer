defmodule VolunteerWeb.Admin.GroupView do
  use VolunteerWeb, :view
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.Admin.SubtitleView
  alias VolunteerWeb.Presenters.Title
  alias VolunteerUtils.Temporal

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def render_subtitle(%{group: group} = assigns) do
    SubtitleView.with_features_nav(:group_subtitle, assigns, %{
      subtitle: Title.bolded(group),
      meta: render("subtitle_meta.html", assigns)
    })
  end

  def definition_list(:details, group, conn) do
    [
      {
        "Region",
        link(Title.bolded(group.region), to: RouterHelpers.admin_region_path(conn, :show, group.region))
      },
    ]
  end

  def definition_list(:meta, group) do
    [
      {"Created at", Temporal.format_datetime!(group.inserted_at)},
      {"Updated at", Temporal.format_datetime!(group.updated_at)},
    ]
  end
end
