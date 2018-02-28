defmodule Volunteer.Apply do
  alias Volunteer.Repo
  alias Volunteer.Apply.Listing
  alias Volunteer.Apply.TKNListing
  alias Volunteer.Apply.Application
  alias Volunteer.Accounts

  def create_listing(attrs, group, organizer) do
    %Listing{}
    |> Listing.changeset(attrs, group, organizer)
    |> Repo.insert()
  end

  def get_listings_for_organizer(%Accounts.User{} = user) do
    Listing.query_all
    |> Listing.query_filter_for_organizer(user)
    |> Repo.all
  end

  def change_listing(%Listing{} = listing \\ %Listing{}) do
    listing
    |> Listing.changeset
  end

end
