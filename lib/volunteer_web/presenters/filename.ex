defprotocol VolunteerWeb.Presenters.Filename do
  def text(data, filename, ext)
  def slugified(data, filename, ext)
end

defimpl VolunteerWeb.Presenters.Filename, for: Volunteer.Listings.Listing do
  def text(listing, filename, ext) do
    "#{listing.id} - #{VolunteerWeb.Presenters.Title.plain(listing)} - #{filename}"
    |> Kernel.<>(".#{ext}")
  end

  def slugified(listing, filename, ext) do
    "#{listing.id} - #{VolunteerWeb.Presenters.Title.plain(listing)} - #{filename}"
    |> Slugify.slugify()
    |> Kernel.<>(".#{ext}")
  end
end
