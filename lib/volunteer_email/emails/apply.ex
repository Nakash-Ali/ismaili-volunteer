defmodule VolunteerEmail.ApplyEmails do
  use VolunteerEmail, :email
  alias VolunteerEmail.Mailer
  alias Volunteer.Apply
  alias VolunteerWeb.Presenters.Title
  
  def marketing_request(%Apply.MarketingRequest{} = marketing_request, %Apply.Listing{} = listing) do
    email =
      Mailer.new_default_email()
      |> to(
        {"Zahra Nurmohamed", "zahra.nurmohamed@iicanada.net"}
      )
      |> cc([
        {"Amaan Ismail", "amaanki786@gmail.com"},
        {"Rahim Ladha", "rahim.ladha@iicanada.net"},
        {listing.organized_by.title, listing.organized_by.primary_email},
        Mailer.system_email(),
      ])
      |> put_header("Reply-To", listing.organized_by.primary_email)
      |> subject("Marketing request - #{Title.text(listing)}")
    
    render_email(VolunteerEmail.MarketingRequestView, email, "all.html",
      marketing_request: marketing_request,
      listing: listing)
  end
end
