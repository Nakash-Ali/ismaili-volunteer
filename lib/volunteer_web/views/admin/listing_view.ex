defmodule VolunteerWeb.Admin.ListingView do
  use VolunteerWeb, :view
  alias Volunteer.Listings
  alias VolunteerWeb.ListingView, as: PublicListingView
  alias VolunteerWeb.FormView
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.Admin.SubtitleView
  alias VolunteerWeb.HTMLHelpers
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

  def group_label(:created), do: "Listings I have created"
  def group_label(:manage), do: "Other listings I can manage"
  def group_label(:other), do: "All other listings"

  def listing_state_text_and_class(listing) do
    if Volunteer.Listings.Public.Introspect.approved?(listing) do
      if Volunteer.Listings.Public.Introspect.expired?(listing) do
        {"Expired and archived", "text-danger"}
      else
        {"Approved and alive", "text-success"}
      end
    else
      {"Requires approval", "text-warning"}
    end
  end

  def expiry_reminder_sent_text(true), do: "Sent"
  def expiry_reminder_sent_text(false), do: "Not sent"

  def approved_text(%{public_approved: approved}), do: approved_text(approved)
  def approved_text(true), do: "Yes, approved"
  def approved_text(false), do: "No, not yet"

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
