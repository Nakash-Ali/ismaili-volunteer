defmodule Volunteer.Apply do
  import Ecto.Query

  alias Volunteer.Repo
  alias Volunteer.Apply.Listing
  alias Volunteer.Apply.TKNListing
  alias Volunteer.Apply.MarketingRequest
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
  
  def refresh_expiry_for_listing!(%Listing{} = listing) do
    listing
    |> Listing.refresh_expiry
    |> Repo.update!()
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

  def get_active_listing!(id) do
    from(l in Listing, where: l.id == ^id)
    |> query_approved_listing
    |> query_not_expired_listing
    |> Repo.one!()
  end
  
  def get_preview_listing!(id) do
    from(l in Listing, where: l.id == ^id)
    |> query_not_expired_listing
    |> Repo.one!()
  end
  
  def query_approved_listing(query) do
    from(l in query, where: l.approved == true)
  end
  
  def query_not_expired_listing(query) do
    current_time = DateTime.utc_now()
    from(l in query, where: l.expiry_date >= ^current_time)
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
  
  def query_tkn_listing_for_listing(id) do
    from(l in TKNListing, where: l.listing_id == ^id)
  end
  
  def get_tkn_listing_for_listing(id) do
    query_tkn_listing_for_listing(id)
    |> Repo.one()
  end
  
  def get_tkn_listing_for_listing!(id) do
    query_tkn_listing_for_listing(id)
    |> Repo.one!()
  end
  
  def new_marketing_request(assigns) do
    MarketingRequest.new(%{}, MarketingRequest.TextChannel.types(), assigns)
  end
  
  def create_marketing_request(attrs) do
    MarketingRequest.changeset(attrs)
  end
end
