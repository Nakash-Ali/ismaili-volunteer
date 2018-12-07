defprotocol VolunteerWeb.Presenters.Filename do
  def text(data, filename, ext)
  def slugified(data, filename, ext)
end

defmodule VolunteerWeb.Presenters.Filename.Utils do
  def append_extension(filename, ext) do
    "#{filename}.#{ext}"
  end
end

defimpl VolunteerWeb.Presenters.Filename, for: Volunteer.Listings.Listing do
  alias VolunteerWeb.Presenters.Filename.Utils

  def text(listing, filename, ext) do
    "#{listing.id} - #{VolunteerWeb.Presenters.Title.text(listing)} - #{filename}"
    |> Utils.append_extension(ext)
  end

  def slugified(listing, filename, ext) do
    "#{listing.id} - #{VolunteerWeb.Presenters.Title.text(listing)} - #{filename}"
    |> Slugify.slugify()
    |> Utils.append_extension(ext)
  end
end
