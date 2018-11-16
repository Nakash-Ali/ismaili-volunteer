defprotocol VolunteerWeb.Presenters.Filename do
  def text(data, suffix)
end

defimpl VolunteerWeb.Presenters.Filename, for: Volunteer.Listings.Listing do
  def text(listing, suffix) do
    "#{listing.id} - #{VolunteerWeb.Presenters.Title.text(listing)} - #{suffix}"
  end
end
