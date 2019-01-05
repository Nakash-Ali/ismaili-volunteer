defprotocol VolunteerWeb.Presenters.Filename do
  def text(data, filename, ext)
  def slugified(data, filename, ext)
end

defimpl VolunteerWeb.Presenters.Filename, for: Volunteer.Listings.Listing do
  def text(listing, filename, ext) do
    "#{listing.id} - #{VolunteerWeb.Presenters.Title.text(listing)} - #{filename}"
    |> VolunteerUtils.File.append_extension(ext)
  end

  def slugified(listing, filename, ext) do
    "#{listing.id} - #{VolunteerWeb.Presenters.Title.text(listing)} - #{filename}"
    |> Slugify.slugify()
    |> VolunteerUtils.File.append_extension(ext)
  end
end
