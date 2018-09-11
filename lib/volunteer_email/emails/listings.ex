defmodule VolunteerEmail.ListingsEmails do
  use VolunteerEmail, :email
  alias VolunteerEmail.Mailer
  alias Volunteer.Listings.{Listing, MarketingRequest}
  alias VolunteerWeb.Presenters.Title

  def marketing_request(%MarketingRequest{} = marketing_request, %Listing{} = listing) do
    email =
      Mailer.new_default_email()
      |> to({"Zahra Nurmohamed", "zahra.nurmohamed@iicanada.net"})
      |> cc([
        {"Amaan Ismail", "amaanki786@gmail.com"},
        {"Rahim Ladha", "rahim.ladha@iicanada.net"},
        {listing.organized_by.title, listing.organized_by.primary_email},
        Mailer.system_email()
      ])
      |> put_header("Reply-To", listing.organized_by.primary_email)
      |> subject("Marketing request - #{Title.text(listing)}")

    render_email(
      VolunteerEmail.ListingsView,
      email,
      "marketing_request.html",
      marketing_request: marketing_request,
      listing: listing
    )
  end

  def expiry_reminder(%Listing{} = listing) do
    email =
      Mailer.new_default_email()
      |> to({listing.organized_by.title, listing.organized_by.primary_email})
      |> cc(Listing.get_cc_emails(listing))
      |> subject("Expiration Reminder! #{Title.text(listing)}")

    render_email(
      VolunteerEmail.ListingsView,
      email,
      "expiry_reminder.html",
      listing: listing
    )
  end
end
