defmodule Volunteer.Listings.TKN do
  alias Volunteer.Repo
  alias Volunteer.Listings.TKN.Change

  def edit(listing) do
    Change.update(listing)
  end

  def update(listing, attrs) do
    Change.update(listing, attrs)
    |> Repo.update()
  end

  def send_assignment_spec(_listing) do
    # TODO: implement this!
  end

  def valid?(listing) do
    listing
    |> Change.update()
    |> Map.fetch!(:valid?)
  end
end
