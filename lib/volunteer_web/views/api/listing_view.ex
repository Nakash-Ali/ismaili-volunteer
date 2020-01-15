defmodule VolunteerWeb.API.ListingView do
  use VolunteerWeb, :view
  alias Volunteer.Listings
  alias VolunteerWeb.ListingView
  alias VolunteerWeb.Presenters.{Title, Related, ISO8601, JSON}

  def render("index.json", %{listings: listings, conn: conn}) do
    Enum.map(listings, &render_listing(&1, conn))
  end

  def render_listing(%Listings.Listing{} = listing, conn) do
    %{
      id: listing.id,
      url: VolunteerWeb.Router.Helpers.listing_url(conn, :show, listing),
      created_by: Related.render!(listing, :created_by),

      approved: listing.public_approved,
      approved_on: ISO8601.stringify(listing.public_approved_on),
      approved_by: Related.render!(listing, :public_approved_by),
      expiry_date: ISO8601.stringify(listing.public_expiry_date),
      
      title: Title.plain(listing),
      position_title: JSON.nilify?(listing.position_title),
      program_title: JSON.nilify?(listing.program_title),
      summary_line: JSON.nilify?(listing.summary_line),
      region: Related.render!(listing, :region),
      group: Related.render!(listing, :group),
      organized_by: Related.render!(listing, :organized_by),
      start_date: ISO8601.stringify(listing.start_date),
      end_date: ISO8601.stringify(listing.end_date),
      start_date_and_end_date_text: ListingView.start_date_and_end_date_text(listing.start_date, listing.end_date),
      time_commitment_amount: listing.time_commitment_amount,
      time_commitment_type: listing.time_commitment_type,
      time_commitment_text: ListingView.time_commitment_text(listing),
      inserted_at: ISO8601.stringify(listing.inserted_at),
      updated_at: ISO8601.stringify(listing.updated_at),
    }
  end

  def render_listing(_listing) do
    nil
  end
end
