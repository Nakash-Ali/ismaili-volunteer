defmodule VolunteerEmail.ListingsEmails do
  use VolunteerEmail, :email
  alias VolunteerEmail.Mailer
  alias Volunteer.Accounts.User
  alias Volunteer.Listings.{Listing, MarketingRequest}
  alias VolunteerWeb.Presenters.Title

  def marketing_request(%MarketingRequest{} = marketing_request, %Listing{} = listing) do
    subject_str = generate_subject("Marketing Request", listing)

    {:ok, to_address_list} =
      Volunteer.Infrastructure.get_region_config(listing.region_id, [:marketing_request, :email])

    cc_address_list = generate_all_address_list(listing)

    reply_to_address = listing.organized_by.primary_email

    email =
      Mailer.new_default_email(listing.region_id)
      |> subject(subject_str)
      |> to(to_address_list)
      |> cc(cc_address_list)
      |> put_header("Reply-To", reply_to_address)

    render_email(
      VolunteerEmail.ListingsView,
      email,
      "marketing_request.html",
      disclaimers: Volunteer.Infrastructure.get_region_config!(listing.region_id, [:disclaimers]),
      marketing_request: marketing_request,
      listing: listing
    )
  end

  def expiry_reminder(%Listing{} = listing) do
    subject_str = generate_subject("Expiration Reminder", listing)

    email =
      Mailer.new_default_email(listing.region_id)
      |> subject(subject_str)
      |> to(generate_primary_address_list(listing))
      |> cc(generate_secondary_address_list(listing))

    render_email(
      VolunteerEmail.ListingsView,
      email,
      "expiry_reminder.html",
      disclaimers: Volunteer.Infrastructure.get_region_config!(listing.region_id, [:disclaimers]),
      listing: listing
    )
  end

  def on_change(%Listing{} = listing, %User{} = changed_by) do
    subject_str = generate_subject("Request for Approval", listing)

    email =
      Mailer.new_default_email(listing.region_id)
      |> subject(subject_str)
      |> to(generate_all_address_list(listing))
      |> cc(changed_by)

    render_email(
      VolunteerEmail.ListingsView,
      email,
      "on_change.html",
      disclaimers: Volunteer.Infrastructure.get_region_config!(listing.region_id, [:disclaimers]),
      listing: listing,
      changed_by: changed_by
    )
  end

  def request_approval(%Listing{} = listing, %User{} = requested_by) do
    subject_str = generate_subject("Request for Approval", listing)

    users_with_approval_permissions =
      Volunteer.Permissions.get_all_allowed_users([:admin, :listing, :approve], listing)

    cc_address_list = [requested_by] ++ generate_all_address_list(listing)

    email =
      Mailer.new_default_email(listing.region_id)
      |> subject(subject_str)
      |> to(users_with_approval_permissions)
      |> cc(cc_address_list)

    render_email(
      VolunteerEmail.ListingsView,
      email,
      "request_approval.html",
      disclaimers: Volunteer.Infrastructure.get_region_config!(listing.region_id, [:disclaimers]),
      listing: listing,
      requested_by: requested_by
    )
  end

  def on_approval(%Listing{} = listing, %User{} = approved_by) do
    on_approve_or_unapprove(
      listing,
      approved_by,
      %{
        subject_prefix: "Listing Approved",
        template: "on_approval.html"
      }
    )
  end

  def on_unapproval(%Listing{} = listing, %User{} = unapproved_by) do
    on_approve_or_unapprove(
      listing,
      unapproved_by,
      %{
        subject_prefix: "Listing Un-approved",
        template: "on_unapproval.html"
      }
    )
  end

  defp on_approve_or_unapprove(%Listing{} = listing, %User{} = action_by, config) do
    users_with_approval_permissions =
      Volunteer.Permissions.get_all_allowed_users([:admin, :listing, :approve], listing)

    subject_str = generate_subject(config.subject_prefix, listing)

    to_address_list = generate_all_address_list(listing)

    cc_address_list = [action_by] ++ users_with_approval_permissions

    email =
      Mailer.new_default_email(listing.region_id)
      |> subject(subject_str)
      |> to(to_address_list)
      |> cc(cc_address_list)

    render_email(
      VolunteerEmail.ListingsView,
      email,
      config.template,
      disclaimers: Volunteer.Infrastructure.get_region_config!(listing.region_id, [:disclaimers]),
      listing: listing,
      action_by: action_by
    )
  end

  def on_applicant_external(listing, user, applicant) do
    subject_str =
      generate_subject(
        [
          Title.text(user),
          "Volunteer Application"
        ],
        listing
      )

    email =
      Mailer.new_default_email(listing.region_id)
      |> to(user)
      |> cc([Mailer.system_email(listing.region_id) | generate_all_address_list(listing)])
      |> subject(subject_str)

    render_email(
      VolunteerEmail.ListingsView,
      email,
      "on_applicant_external.html",
      disclaimers: Volunteer.Infrastructure.get_region_config!(listing.region_id, [:disclaimers]),
      listing: listing,
      user: user,
      applicant: applicant
    )
  end

  def on_applicant_internal(listing, user, applicant) do
    subject_str =
      generate_subject(
        [
          "INTERNAL",
          Title.text(user),
          "Volunteer Application"
        ],
        listing
      )

    email =
      Mailer.new_default_email(listing.region_id)
      |> to(generate_primary_address_list(listing))
      |> cc([Mailer.system_email(listing.region_id) | generate_secondary_address_list(listing)])
      |> subject(subject_str)

    render_email(
      VolunteerEmail.ListingsView,
      email,
      "on_applicant_internal.html",
      disclaimers: Volunteer.Infrastructure.get_region_config!(listing.region_id, [:disclaimers]),
      listing: listing,
      user: user,
      applicant: applicant
    )
  end

  defp generate_subject(prefixes, listing) when is_list(prefixes) do
    "#{Enum.join(prefixes, " - ")} --- #{Title.text(listing)}"
  end

  defp generate_subject(prefix, listing) when not is_list(prefix) do
    generate_subject([prefix], listing)
  end

  defp generate_all_address_list(%Listing{} = listing) do
    generate_primary_address_list(listing) ++ generate_secondary_address_list(listing)
  end

  defp generate_primary_address_list(%Listing{} = listing) do
    [
      listing.created_by,
      listing.organized_by
    ]
  end

  defp generate_secondary_address_list(%Listing{} = listing) do
    Listing.get_cc_emails(listing)
  end
end
