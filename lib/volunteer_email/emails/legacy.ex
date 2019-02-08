defmodule VolunteerEmail.LegacyEmails do
  use VolunteerEmail, :email
  alias VolunteerEmail.Mailer

  def external(%Volunteer.Legacy{} = data, listing) do
    email =
      Mailer.new_default_email(listing.region_id)
      |> to({data.name, data.email})
      |> cc([Mailer.system_email(listing.region_id), {data.organizer, data.organizer_email} | data.cc])
      |> subject(construct_subject(data))

    render_email(VolunteerEmail.LegacyView, email, :external_for_new_application, data: data)
  end

  def internal(%Volunteer.Legacy{} = data, listing) do
    email =
      Mailer.new_default_email(listing.region_id)
      |> to({data.organizer, data.organizer_email})
      |> cc([Mailer.system_email(listing.region_id) | data.cc])
      |> subject("INTERNAL - #{construct_subject(data)}")

    render_email(VolunteerEmail.LegacyView, email, :internal_for_new_application, data: data)
  end

  def construct_subject(%Volunteer.Legacy{} = data) do
    "#{data.name} - #{data.position} - #{data.program} - Volunteer Application"
  end
end
