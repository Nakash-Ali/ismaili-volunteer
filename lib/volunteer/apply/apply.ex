defmodule Volunteer.Apply do
  import Ecto.Query
  
  alias Volunteer.Repo
  alias Volunteer.Apply.Listing
  alias Volunteer.Apply.TKNListing
  alias Volunteer.Apply.Application
  alias Volunteer.Accounts

  def new_listing do
    Listing.new
  end

  def create_listing(attrs, created_by) do
    %Listing{}
    |> Listing.create(attrs, created_by)
    |> Repo.insert()
  end
  
  def edit_listing(%Listing{} = listing, attrs \\ %{}) do
    listing |> Listing.edit(attrs)
  end
  
  def update_listing(%Listing{} = listing, attrs \\ %{}) do
    listing
    |> edit_listing(attrs)
    |> Repo.update
  end
  
  def delete_listing(%Listing{} = listing) do
    listing |> Repo.delete
  end
  
  def approve_listing!(%Listing{} = listing, approved_by) do
    listing
    |> Listing.approve(approved_by)
    |> Repo.update!
  end
  
  def unapprove_listing!(%Listing{} = listing) do
    listing
    |> Listing.unapprove
    |> Repo.update!
  end
  
  def preload_listing_all(%Listing{} = listing) do
    listing |> Repo.preload([:created_by, :approved_by, :group, :organized_by])
  end

  def get_all_listings_created_by(%Accounts.User{id: id}) do
    from(l in Listing,
      where: l.created_by_id == ^id)
    |> Repo.all
  end
  
  def get_approved_listings do
    from(l in Listing,
      where: l.approved == true)
    |> Repo.all
  end
  
  def get_listing!(id) do
    Listing |> Repo.get!(id)
  end
end
