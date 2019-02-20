defmodule VolunteerWeb.Admin.ApplicantView do
  use VolunteerWeb, :view
  alias VolunteerWeb.HTMLHelpers
  alias VolunteerWeb.Admin.ListingView
  alias VolunteerWeb.Presenters.{Title, Temporal}

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def applicant_updated_and_inserted_at(applicant) do
    updated_at =
      if VolunteerUtils.Temporal.is?(applicant.updated_at, :newer, applicant.user.updated_at) do
        applicant.updated_at
      else
        applicant.user.updated_at
      end

    if VolunteerUtils.Temporal.is?(updated_at, :equal, applicant.inserted_at) do
      "created #{Temporal.relative(applicant.inserted_at)}"
    else
      "created #{Temporal.relative(applicant.inserted_at)}, updated later"
    end
  end

  def confirm_availability_text(%{confirm_availability: true}) do
    "Available"
  end

  def confirm_availability_text(%{confirm_availability: false}) do
    "Not available"
  end

  def definition_list(:details, applicant) do
    [
      {"Confirm availability", confirm_availability_text(applicant)},
      {"Additional information", applicant.additional_info},
      {"How did you hear about this listing", applicant.hear_about},
    ]
  end
end
