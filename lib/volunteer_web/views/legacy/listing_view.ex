defmodule VolunteerWeb.Legacy.ListingView do
  use VolunteerWeb, :view
  alias VolunteerWeb.Presenters.{Title, JSON}

  @env Application.fetch_env!(:volunteer, Volunteer.Legacy)

  def submit_url() do
    Keyword.fetch!(@env, :submit_url)
  end

  def form_data(listing) do
    %{
      approved: listing.approved,
      cc: listing.cc_emails |> String.split(","),
      organizer: Title.text(listing.organized_by),
      organizer_email: listing.organized_by.primary_email,
      basename: Slugify.slugify(listing)
    }
    |> JSON.encode_for_client()
  end
end
