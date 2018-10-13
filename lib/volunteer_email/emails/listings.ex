defmodule VolunteerEmail.ListingsEmails do
  use VolunteerEmail, :email
  alias VolunteerEmail.Mailer
  alias Volunteer.Accounts.User
  alias Volunteer.Listings.Listing
  alias VolunteerWeb.Presenters.Title

  # def marketing_request(%MarketingRequest{} = marketing_request, %Listing{} = listing) do
  #   email =
  #     Mailer.new_default_email()
  #     |> to({"Zahra Nurmohamed", "zahra.nurmohamed@iicanada.net"})
  #     |> cc([
  #       {"Amaan Ismail", "amaanki786@gmail.com"},
  #       {"Rahim Ladha", "rahim.ladha@iicanada.net"},
  #       {listing.organized_by.title, listing.organized_by.primary_email},
  #       Mailer.system_email()
  #     ])
  #     |> put_header("Reply-To", listing.organized_by.primary_email)
  #     |> subject("Marketing request - #{Title.text(listing)}")
  #
  #   render_email(
  #     VolunteerEmail.ListingsView,
  #     email,
  #     "marketing_request.html",
  #     marketing_request: marketing_request,
  #     listing: listing
  #   )
  # end

  def expiry_reminder(%Listing{} = listing) do
    subject_str = "Expiration Reminder! #{Title.text(listing)}"

    email =
      Mailer.new_default_email()
      |> to(generate_primary_address_list(listing))
      |> cc(generate_secondary_address_list(listing))
      |> subject(subject_str)

    render_email(
      VolunteerEmail.ListingsView,
      email,
      "expiry_reminder.html",
      listing: listing
    )
  end

  def on_approval(%Listing{} = listing, %User{} = approved_by, to_notify_address_list) do
    subject_str = "Listing Approved! #{Title.text(listing)}"

    to_emails =
      to_notify_address_list ++ generate_primary_address_list(listing) ++ generate_secondary_address_list(listing)

    cc_emails = [approved_by]

    email =
      Mailer.new_default_email()
      |> to(to_emails)
      |> cc(cc_emails)
      |> subject(subject_str)

    render_email(
      VolunteerEmail.ListingsView,
      email,
      "on_approval.html",
      listing: listing,
      approved_by: approved_by
    )
  end

  defp generate_primary_address_list(%Listing{} = listing) do
    [
      listing.created_by,
      listing.organized_by,
    ]
  end

  defp generate_secondary_address_list(%Listing{} = listing) do
    Listing.get_cc_emails(listing)
  end
end
