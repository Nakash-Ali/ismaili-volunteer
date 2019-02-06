defmodule VolunteerWeb.Admin.ListingView do
  use VolunteerWeb, :view
  alias Volunteer.Listings
  alias VolunteerWeb.FormView
  alias VolunteerWeb.ListingView, as: PublicListingView
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.Presenters.{Title, Temporal}

  def render("body_extra" <> page, %{conn: conn}) when page in [".edit.html", ".new.html"] do
    [
      StaticHelpers.script_tag(conn, "/js/drafterize_form.js"),
      StaticHelpers.script_tag(conn, "/js/char_count.js"),
      render(VolunteerWeb.VendorView, "trix.html"),
    ]
  end

  def render("head_extra" <> page, %{conn: conn}) when page in [".edit.html", ".new.html"] do
    [
      # render(VolunteerWeb.VendorView, "choices.html"),
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css"),
    ]
  end

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def sub_title_nav(%{conn: conn, listing: listing, active_nav: active_nav}) do
    [
      {"Info", RouterHelpers.admin_listing_path(conn, :show, listing)},
      {"TKN", RouterHelpers.admin_listing_tkn_listing_path(conn, :show, listing)},
      {"Marketing", RouterHelpers.admin_listing_marketing_request_path(conn, :show, listing)}
    ]
    |> Enum.map(fn {title, path} ->
      case String.downcase(title) do
        ^active_nav ->
          {title, path, "active"}

        _ ->
          {title, path, ""}
      end
    end)
  end

  def listing_state_text_and_class(listing) do
    if Volunteer.Listings.Listing.is_expired?(listing) do
      {"Expired and archived", "text-danger"}
    else
      if Volunteer.Listings.Listing.is_approved?(listing) do
        {"Approved and alive", "text-success"}
      else
        {"Requires approval", "text-warning"}
      end
    end
  end

  def expiry_reminder_sent_text(true), do: "Sent"
  def expiry_reminder_sent_text(false), do: "Not sent"

  def approved_text(%{approved: approved}), do: approved_text(approved)
  def approved_text(true), do: "Yes, approved"
  def approved_text(false), do: "No, not yet"

  def definition_list(:reference, listing) do
    definition_list(:links, listing) ++
      [
        {"Title", Title.text(listing)},
        {"Region", listing.region.title},
        {"Organizing group", listing.group.title}
      ]
  end

  def definition_list(:expiry, listing) do
    [
      {"Expiry date", PublicListingView.expiry_datetime_text(listing.expiry_date)},
      {"Expiry reminder", expiry_reminder_sent_text(listing.expiry_reminder_sent)}
    ]
  end

  def definition_list(:approval, listing) do
    if Listings.Listing.is_approved?(listing) do
      [
        {"Approved?", approved_text(listing)},
        {"Approved by", listing.approved_by.title},
        {"Approval date", Temporal.format_datetime(listing.approved_on)}
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
      {"Time commitment", PublicListingView.time_commitment_text(listing)}
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
      {"Creation date", Temporal.format_datetime(listing.inserted_at)},
      {"Last updated date", Temporal.format_datetime(listing.updated_at)}
    ]
  end

  def definition_list(:links, listing) do
    url = RouterHelpers.admin_listing_url(VolunteerWeb.Endpoint, :show, listing)

    [
      {"URL", link(url, to: url)}
    ]
  end
end
