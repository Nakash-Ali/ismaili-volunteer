defimpl Slugify, for: Volunteer.Listings.Listing do
  def slugify(listing) do
    "#{listing.id} #{VolunteerWeb.Presenters.Title.plain(listing)}"
    |> String.downcase()
    |> Slugger.slugify()
  end
end
