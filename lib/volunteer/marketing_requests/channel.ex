defmodule Volunteer.MarketingRequests.Channel do
  def id(title, %{listing: %{id: listing_id}}) do
    "#{listing_id} #{title}"
    |> String.downcase()
    |> Slugger.slugify()
  end
end
