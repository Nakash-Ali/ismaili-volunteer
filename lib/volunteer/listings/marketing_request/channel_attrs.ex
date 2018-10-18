defmodule Volunteer.Listings.MarketingRequest.ChannelAttrs do
  @all [
         :enabled,
         :title,
         :text,
         :image_url
       ]
       |> MapSet.new()

  def cast_always(module) do
    module.__schema__(:fields)
    |> MapSet.new()
    |> MapSet.intersection(@all)
    |> MapSet.to_list()
  end

  def required_always(module) do
    cast_always(module)
  end
end
