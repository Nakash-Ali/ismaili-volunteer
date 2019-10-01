defmodule VolunteerWeb.API.ListingView do
  use VolunteerWeb, :view
  alias Volunteer.Listings
  alias VolunteerWeb.ListingView
  alias VolunteerWeb.API.{RelatedHelpers, DataHelpers}
  alias VolunteerWeb.Presenters.Title

  def render("index.json", %{listings: listings, conn: conn}) do
    Enum.map(listings, &render_listing(&1, conn))
  end

  def render_listing(%Listings.Listing{} = listing, conn) do
    %{
      id: listing.id,
      url: VolunteerWeb.Router.Helpers.listing_url(conn, :show, listing),
      expiry_date: DataHelpers.to_iso8601(listing.expiry_date),
      created_by: RelatedHelpers.render!(listing, :created_by),
      approved: listing.approved,
      approved_on: DataHelpers.to_iso8601(listing.approved_on),
      approved_by: RelatedHelpers.render!(listing, :approved_by),
      title: Title.plain(listing),
      position_title: DataHelpers.nilify?(listing.position_title),
      program_title: DataHelpers.nilify?(listing.program_title),
      summary_line: DataHelpers.nilify?(listing.summary_line),
      region: RelatedHelpers.render!(listing, :region),
      group: RelatedHelpers.render!(listing, :group),
      organized_by: RelatedHelpers.render!(listing, :organized_by),
      start_date: DataHelpers.to_iso8601(listing.start_date),
      end_date: DataHelpers.to_iso8601(listing.end_date),
      start_date_and_end_date_text: ListingView.start_date_and_end_date_text(listing.start_date, listing.end_date),
      time_commitment_amount: listing.time_commitment_amount,
      time_commitment_type: listing.time_commitment_type,
      time_commitment_text: ListingView.time_commitment_text(listing),
      inserted_at: DataHelpers.to_iso8601(listing.inserted_at),
      updated_at: DataHelpers.to_iso8601(listing.updated_at),
    }
  end

  def render_listing(_listing) do
    nil
  end
end
