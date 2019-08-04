defmodule VolunteerWeb.Admin.UserView do
  use VolunteerWeb, :view
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.Presenters.{Title, Temporal}

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def preferred_contact_text(%{preferred_contact: preferred_contact}) do
    Volunteer.Accounts.User.preferred_contact_choices()
    |> VolunteerUtils.Choices.labels(preferred_contact)
    |> Enum.join(" & ")
  end

  def ismaili_status_text(%{ismaili_status: ismaili_status}) do
    VolunteerUtils.Choices.label(
      Volunteer.Accounts.User.ismaili_status_choices(),
      ismaili_status
    )
  end

  def primary_jamatkhanas_text(%{primary_jamatkhanas: primary_jamatkhanas}) do
    List.first(primary_jamatkhanas)
  end

  def education_level_text(%{education_level: education_level}) do
    VolunteerUtils.Choices.label(
      Volunteer.Accounts.User.education_level_choices(),
      education_level
    )
  end

  def definition_list(:details, user) do
    [
      {"Title", Title.text(user)},
      {"Email", user.primary_email},
      {"Phone", user.primary_phone},
      {"Preferred contact method", preferred_contact_text(user)},
      {"Primary Jamatkhana", primary_jamatkhanas_text(user)},
      {"Ismaili Muslim", ismaili_status_text(user)},
      {"Education level", education_level_text(user)},
    ]
  end
end
