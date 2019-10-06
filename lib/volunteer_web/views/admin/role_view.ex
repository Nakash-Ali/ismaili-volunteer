defmodule VolunteerWeb.Admin.RoleView do
  use VolunteerWeb, :view
  alias VolunteerWeb.FormView
  alias VolunteerWeb.TemporalView
  alias VolunteerUtils.Temporal
  alias VolunteerWeb.Presenters.Title

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def render_subject_subtitle(%{subject_type: :region} = assigns) do
    assigns
    |> Map.put(:region, assigns[:subject])
    |> VolunteerWeb.Admin.RegionView.render_subtitle()
  end

  def render_subject_subtitle(%{subject_type: :group} = assigns) do
    assigns
    |> Map.put(:group, assigns[:subject])
    |> VolunteerWeb.Admin.GroupView.render_subtitle()
  end

  def render_subject_subtitle(%{subject_type: :listing} = assigns) do
    assigns
    |> Map.put(:listing, assigns[:subject])
    |> VolunteerWeb.Admin.ListingView.render_subtitle()
  end
end
