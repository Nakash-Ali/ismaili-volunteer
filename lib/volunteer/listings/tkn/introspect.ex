defmodule Volunteer.Listings.TKN.Introspect do
  alias Volunteer.Listings.TKN.Change
  
  def valid?(listing) do
    listing
    |> Change.changeset()
    |> Map.fetch!(:valid?)
  end
end
