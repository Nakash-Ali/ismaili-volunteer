defmodule VolunteerEmail.ListingsEmails do
  use VolunteerEmail, :email
  alias VolunteerEmail.{Mailer, Tools}
  alias Volunteer.Accounts.User
  alias Volunteer.Listings.{Listing, MarketingRequest}
  alias VolunteerWeb.Presenters.Title

  def marketing_request(%MarketingRequest{} = marketing_request, %Listing{} = listing) do
    subject_str = generate_subject("Marketing Request", listing)

    {:ok, to_address_list} =
      Volunteer.Infrastructure.get_region_config(listing.region_id, [:marketing_request, :email])

    email =
      Mailer.new_default_email(listing.region_id)
      |> subject(subject_str)
      |> Tools.append(:to, to_address_list)
      |> Tools.append(:cc, generate_all_address_list(listing))

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
      |> Tools.append(:to, generate_primary_address_list(listing))
      |> Tools.append(:cc, generate_secondary_address_list(listing))

    render_email(
      VolunteerEmail.ListingsView,
      email,
      "expiry_reminder.html",
      disclaimers: Volunteer.Infrastructure.get_region_config!(listing.region_id, [:disclaimers]),
      listing: listing
    )
  end

  # def on_change(%Listing{} = listing, %User{} = changed_by) do
  #   subject_str = generate_subject("Change", listing)
  #
  #   email =
  #     Mailer.new_default_email(listing.region_id)
  #     |> subject(subject_str)
  #     |> Tools.append(:to, generate_all_address_list(listing))
  #     |> Tools.append(:cc, changed_by)
  #
  #   render_email(
  #     VolunteerEmail.ListingsView,
  #     email,
  #     "on_change.html",
  #     disclaimers: Volunteer.Infrastructure.get_region_config!(listing.region_id, [:disclaimers]),
  #     listing: listing,
  #     changed_by: changed_by
  #   )
  # end

  def request_approval(%Listing{} = listing, %User{} = requested_by) do
    subject_str = generate_subject("Request for Approval", listing)

    email =
      Mailer.new_default_email(listing.region_id)
      |> subject(subject_str)
      |> Tools.append(:to, Volunteer.Permissions.get_all_allowed_users([:admin, :listing, :approve], listing))
      |> Tools.append(:cc, Volunteer.Roles.get_users_with_subject_roles(:region, listing.region_id, ["cc_team"]))
      |> Tools.append(:cc, generate_all_address_list(listing))
      |> Tools.append(:cc, requested_by)

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
        subject_prefix: "Listing Unapproved",
        template: "on_unapproval.html"
      }
    )
  end

  defp on_approve_or_unapprove(%Listing{} = listing, %User{} = action_by, config) do
    subject_str = generate_subject(config.subject_prefix, listing)

    email =
      Mailer.new_default_email(listing.region_id)
      |> subject(subject_str)
      |> Tools.append(:to, generate_all_address_list(listing))
      |> Tools.append(:cc, Volunteer.Permissions.get_all_allowed_users([:admin, :listing, :approve], listing))
      |> Tools.append(:cc, action_by)

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
          Title.plain(user),
          "Volunteer Application"
        ],
        listing
      )

    email =
      Mailer.new_default_email(listing.region_id)
      |> Tools.append(:to, user)
      |> Tools.append(:cc, generate_all_address_list(listing))
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
          Title.plain(user),
          "Volunteer Application"
        ],
        listing
      )

    email =
      Mailer.new_default_email(listing.region_id)
      |> Tools.append(:to, generate_primary_address_list(listing))
      |> Tools.append(:cc, generate_secondary_address_list(listing))
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
    "#{Enum.join(prefixes, " - ")} --- #{Title.plain(listing)}"
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
