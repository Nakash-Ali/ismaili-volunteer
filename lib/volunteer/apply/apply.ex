defmodule Volunteer.Apply do
  import Ecto.Query

  alias Volunteer.Repo
  alias Volunteer.Apply.Listing
  alias Volunteer.Apply.TKNListing
  alias Volunteer.Accounts

  def new_listing do
    Listing.new()
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
    |> Repo.update()
  end

  def delete_listing(%Listing{} = listing) do
    listing |> Repo.delete()
  end

  def approve_listing!(%Listing{} = listing, approved_by) do
    listing
    |> Listing.approve(approved_by)
    |> Repo.update!()
  end

  def unapprove_listing!(%Listing{} = listing) do
    listing
    |> Listing.unapprove()
    |> Repo.update!()
  end

  def preload_listing_all(%Listing{} = listing) do
    listing |> Repo.preload([:created_by, :approved_by, :region, :group, :organized_by])
  end

  def get_all_listings do
    from(l in Listing)
    |> Repo.all()
  end

  def get_all_listings_for_user(%Accounts.User{id: id}) do
    from(l in Listing, where: l.created_by_id == ^id or l.organized_by_id == ^id)
    |> Repo.all()
  end

  def get_approved_listings do
    from(l in Listing, where: l.approved == true)
    |> Repo.all()
  end

  def get_listing!(id) do
    Listing |> Repo.get!(id)
  end

  def get_listing_if_approved!(id) do
    from(l in Listing, where: l.id == ^id and l.approved == true)
    |> Repo.one!()
  end

  def new_tkn_listing() do
    TKNListing.changeset(%TKNListing{}, %{})
  end

  def create_tkn_listing(attrs, listing) do
    TKNListing.changeset(%TKNListing{}, attrs, listing)
    |> Repo.insert()
  end

  def edit_tkn_listing(tkn_listing) do
    TKNListing.changeset(tkn_listing, %{})
  end

  def update_tkn_listing(tkn_listing, attrs) do
    TKNListing.changeset(tkn_listing, attrs)
    |> Repo.update()
  end

  def get_tkn_listing!(id) do
    TKNListing
    |> Repo.get!(id)
  end
  
  def get_tkn_listing(id) do
    TKNListing
    |> Repo.get(id)
  end
  
  def delete_tkn_listing(%TKNListing{} = tkn_listing) do
    tkn_listing |> Repo.delete()
  end
  
  def get_tkn_listing_for_listing_query(id) do
    from(l in TKNListing, where: l.listing_id == ^id)
  end
  
  def get_tkn_listing_for_listing(id) do
    get_tkn_listing_for_listing_query(id)
    |> Repo.one()
  end
  
  def get_tkn_listing_for_listing!(id) do
    get_tkn_listing_for_listing_query(id)
    |> Repo.one!()
  end
end
