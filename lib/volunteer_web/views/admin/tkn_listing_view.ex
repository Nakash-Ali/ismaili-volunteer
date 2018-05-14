defmodule VolunteerWeb.Admin.TKNListingView do
  use VolunteerWeb, :view
  alias VolunteerWeb.FormView
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.ListingView, as: PublicListingView
  alias VolunteerWeb.Admin.ListingView
  alias VolunteerWeb.Presenters.Title
  
  def render("head_extra" <> _, %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end
  
  def generate_assignment_data(%{conn: conn, listing: listing, tkn_listing: tkn_listing}) do
    %{
      country: "Canada",
      group: listing.group.title,
      program_title: listing.program_title,
      summary_line: listing.summary_line,
      organized_by_name: listing.organized_by.title,
      organized_by_email: listing.organized_by.primary_email,
      organized_by_phone: listing.organized_by.primary_phone,
      position_title: Title.text(listing),
      industry: tkn_listing.industry,
      function: tkn_listing.function,
      work_experience_level: tkn_listing.work_experience_level,
      education_level: tkn_listing.education_level,
      openings: tkn_listing.openings,
      start_date: PublicListingView.start_date_text(listing.start_date),
      end_date: PublicListingView.end_date_text(listing.end_date),
      commitment_type: tkn_listing.commitment_type,
      hours_per_week: listing.hours_per_week,
      location_type: tkn_listing.location_type,
      search_scope: tkn_listing.search_scope,
      responsibilities: listing.responsibilities,
      qualifications: listing.qualifications,
      suggested_keywords: tkn_listing.suggested_keywords,
    }
    |> Poison.encode!
    |> Base.encode64
    |> Phoenix.HTML.raw
  end
  
  def generate_assignment_output_filename(%{conn: conn, listing: listing}) do
    "#{listing.id} - #{Title.text(listing)} - TKN Assignment Specification"
  end
end
