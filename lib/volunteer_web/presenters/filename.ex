defprotocol VolunteerWeb.Presenters.Filename do
  def text(data, filename, ext)
  def slugified(data, filename, ext)
end

defimpl VolunteerWeb.Presenters.Filename, for: Volunteer.Listings.Listing do
  def text(listing, filename, ext) do
    "#{listing.id} - #{VolunteerWeb.Presenters.Title.plain(listing)} - #{filename}"
    |> VolunteerUtils.File.append_extension(ext)
  end

  def slugified(listing, filename, ext) do
    "#{listing.id} - #{VolunteerWeb.Presenters.Title.plain(listing)} - #{filename}"
    |> VolunteerWeb.Presenters.Slugify.slugify()
    |> VolunteerUtils.File.append_extension(ext)
  end
end
