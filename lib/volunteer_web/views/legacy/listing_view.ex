defmodule VolunteerWeb.Legacy.ListingView do
  use VolunteerWeb, :view
  
  @env Application.fetch_env!(:volunteer, Volunteer.Legacy)
  
  def submit_url() do
    Keyword.fetch!(@env, :submit_url)
  end
  
  def form_data(listing) do
    %{
      approved: listing.approved,
      cc: [],
      organizer: listing.organized_by.title,
      organizer_email: listing.organized_by.primary_email,
      basename: Slugify.slugify(listing)
    }
    |> Poison.encode!
    |> Base.encode64
    |> Phoenix.HTML.raw
  end
end
