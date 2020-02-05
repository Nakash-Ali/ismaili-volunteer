defmodule VolunteerWeb.Admin.ListingView do
  use VolunteerWeb, :view
  alias Volunteer.Listings
  alias VolunteerWeb.ListingView, as: PublicListingView
  alias VolunteerWeb.FormView
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.Admin.SubtitleView
  alias VolunteerWeb.Presenters.Title
  alias VolunteerWeb.WorkflowView
  alias VolunteerUtils.Temporal

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def render("body_extra" <> page, %{conn: conn}) when page in [".edit.html", ".new.html"] do
    [
      StaticHelpers.script_tag(conn, "/js/drafterize_form.js"),
      render(VolunteerWeb.VendorView, "datepicker.html"),
      render(VolunteerWeb.VendorView, "trix.html"),
    ]
  end

  def render_subtitle(%{listing: listing} = assigns) do
    SubtitleView.with_features_nav(:listing_subtitle, assigns, %{
      subtitle: Title.bolded(listing),
      meta: render("subtitle_meta.html", assigns)
    })
  end

  def workflow(%{conn: conn, listing: listing}) do
    [
      %WorkflowView.Step{
        title: "The Public Workflow",
        state: :start,
        content: "The Public Workflow enables you to publish a listing on OTS, have Jamati members apply directly on the website, and get marketing on Jamati channels (JK announcements, social media, etc...)."
      },
      %WorkflowView.Step{
        title: "Manage Approvals",
        state: (
          if Listings.Public.Introspect.approved?(listing) do
            if Listings.Public.Introspect.expired?(listing) do
              :not_relevant
            else
              :complete
            end
          else
            :in_progress
          end
        ),
        content: (
          if Listings.Public.Introspect.approved?(listing) do
            if Listings.Public.Introspect.expired?(listing) do
              nil
            else
              "Congratulations, this listing is approved and publically accessible on OTS."
            end
          else
            "Listings must be approved before they can be published on OTS."
          end
        ),
        actions: (
          if Listings.Public.Introspect.approved?(listing) do
            if Listings.Public.Introspect.expired?(listing) do
              []
            else
              [
                HTMLHelpers.link_action_allowed(
                  allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :public, :unapprove], listing),
                  text: HTMLHelpers.icon_with_text("far fa-thumbs-down", "Un-approve"),
                  to: RouterHelpers.admin_listing_public_path(conn, :unapprove, listing),
                  method: :post,
                  btn: "outline-warning"
                ),
              ]
            end
          else
            [
              HTMLHelpers.link_action_allowed(
                allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :public, :approve], listing),
                text: HTMLHelpers.icon_with_text("far fa-thumbs-up", "Approve"),
                to: RouterHelpers.admin_listing_public_path(conn, :approve_confirmation, listing),
                btn: "outline-success"
              ),
              HTMLHelpers.link_action_allowed(
                allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :public, :request_approval], listing),
                text: "Request Approval",
                to: RouterHelpers.admin_listing_public_path(conn, :request_approval, listing),
                method: :post
              )
            ]
          end
        ),
      },
      %WorkflowView.Step{
        title: "Manage Expiry",
        state: (
          if Listings.Public.Introspect.approved?(listing) do
            if Listings.Public.Introspect.expired?(listing) or Listings.Public.Introspect.expiry_reminder_sent?(listing) do
              :warning
            else
              :complete
            end
          else
            :not_relevant
          end
        ),
        content: (
          if Listings.Public.Introspect.approved?(listing) do
            cond do
              Listings.Public.Introspect.expired?(listing) ->
                "This listing is expired and archived. It is no longer publically accessible on OTS."

              Listings.Public.Introspect.expiry_reminder_sent?(listing) and not Listings.Public.Introspect.expired?(listing) ->
                "This listing will expire in " <> VolunteerUtils.Temporal.format_relative(listing.public_expiry_date) <> ", refrsh it if you're not finished with it."

              true ->
                nil
            end
          else
            nil
          end
        ),
        actions: (
          if Listings.Public.Introspect.approved?(listing) do
            if Listings.Public.Introspect.expired?(listing) do
              [
                HTMLHelpers.link_action_allowed(
                  allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :public, :reset], listing),
                  text: "Reset Workflow",
                  to: RouterHelpers.admin_listing_public_path(conn, :reset, listing),
                  method: :post
                )
              ]
            else
              [
                HTMLHelpers.link_action_allowed(
                  allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :public, :refresh], listing),
                  text: HTMLHelpers.icon_with_text("far fa-sync-alt", "Refresh expiry"),
                  to: RouterHelpers.admin_listing_public_path(conn, :refresh, listing),
                  method: :post
                ),
                HTMLHelpers.link_action_allowed(
                  allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :public, :expire], listing),
                  text: HTMLHelpers.icon_with_text("far fa-times-circle", "Expire and archive"),
                  to: RouterHelpers.admin_listing_public_path(conn, :expire, listing),
                  method: :post,
                  data: [confirm: "Are you sure?"]
                )
              ]
            end
          else
            []
          end
        ),
      },
      %WorkflowView.Step{
        title: "Marketing on Jamati Channels",
        state: (
          if Listings.Public.Introspect.public?(listing) do
            :in_progress
          else
            :not_relevant
          end
        ),
        actions: (
          if Listings.Public.Introspect.public?(listing) do
            [
              HTMLHelpers.link_action_allowed(
                allowed?: ConnPermissions.is_allowed?(conn, [:admin, :listing, :marketing_request, :new], listing),
                text: HTMLHelpers.icon_with_text("far fa-bullhorn", "Send marketing request"),
                to: RouterHelpers.admin_listing_marketing_request_path(conn, :new, listing)
              ),
              HTMLHelpers.link_action_allowed(
                allowed?: true,
                text: HTMLHelpers.icon_with_text("far fa-image", "View shareable image"),
                to: RouterHelpers.listing_social_image_path(conn, :png, listing)
              )
            ]
          else
            []
          end
        ),
      },
    ]
  end

  def group_label(:created), do: "Listings I have created"
  def group_label(:manage), do: "Other listings I can manage"
  def group_label(:other), do: "All other listings"

  def listing_state_text_and_class(listing) do
    if Listings.Public.Introspect.approved?(listing) do
      if Listings.Public.Introspect.expired?(listing) do
        {"Expired and archived", "text-danger"}
      else
        {"Approved", "text-success"}
      end
    else
      {"Non-public", "text-warning"}
    end
  end

  def expiry_reminder_sent_text(true), do: "Sent"
  def expiry_reminder_sent_text(false), do: "Not sent"

  def approved_text(%{public_approved: approved}), do: approved_text(approved)
  def approved_text(true), do: "Yes, approved"
  def approved_text(false), do: "No, not yet approved"

  def qualifications_required_text(%{qualifications_required: qualifications_required}) do
    VolunteerUtils.Choices.labels(
      Listings.Change.qualifications_required_choices(),
      qualifications_required
    )
  end

  def definition_list(:reference, listing) do
    definition_list(:links, listing) ++
      [
        {"Title", Title.plain(listing)},
        {"Region", listing.region.title},
        {"Organizing group", listing.group.title}
      ]
  end

  # TODO: figure out if we should use the same condition as the :approval case below.
  # Or if in both cases, we should show all fields
  def definition_list(:expiry, listing) do
    [
      {"Expiry date", PublicListingView.expiry_datetime_text(listing.public_expiry_date) |> HTMLHelpers.default_if_blank?},
      {"Expiry reminder", expiry_reminder_sent_text(listing.public_expiry_reminder_sent)}
    ]
  end

  def definition_list(:approval, listing) do
    if Listings.Public.Introspect.approved?(listing) do
      [
        {"Approved?", approved_text(listing)},
        {"Approved by", Title.plain(listing.public_approved_by)},
        {"Approved at", Temporal.format_datetime!(listing.public_approved_on)}
      ]
    else
      [
        {"Approved?", approved_text(listing)}
      ]
    end
  end

  def definition_list(:details, listing) do
    [
      {"Position title", listing.position_title},
      {"Program title", listing.program_title},
      {"Summary", listing.summary_line},
      {"Region", listing.region.title},
      {"Organizing group", listing.group.title},
      {"Organizing user", listing.organized_by.title},
      {"CC'ed emails", listing.cc_emails},
      {"Start date", PublicListingView.start_date_text(listing.start_date)},
      {"End date", PublicListingView.end_date_text(listing.end_date)},
      {"Time commitment", PublicListingView.time_commitment_text(listing)},
      {"Qualifications required", qualifications_required_text(listing) |> HTMLHelpers.with_line_breaks()}
    ]
  end

  def definition_list(:textblob, listing) do
    [
      {"About the program", PublicListingView.transform_textblob_content(listing.program_description)},
      {"About the role", PublicListingView.transform_textblob_content(listing.responsibilities)},
      {"About the applicant", PublicListingView.transform_textblob_content(listing.qualifications)}
    ]
  end

  def definition_list(:meta, listing) do
    [
      {"Created by", listing.created_by.title},
      {"Created at", Temporal.format_datetime!(listing.inserted_at)},
      {"Updated at", Temporal.format_datetime!(listing.updated_at)}
    ]
  end

  def definition_list(:links, listing) do
    url = RouterHelpers.admin_listing_url(VolunteerWeb.Endpoint, :show, listing)

    [
      {"URL", link(url, to: url)}
    ]
  end
end
