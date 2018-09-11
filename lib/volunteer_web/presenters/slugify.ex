defimpl Slugify, for: Volunteer.Listings.Listing do
  def slugify(listing) do
    "#{listing.id} #{VolunteerWeb.Presenters.Title.text(listing)}"
    |> String.downcase()
    |> Slugger.slugify()
  end
end
