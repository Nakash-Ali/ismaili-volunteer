defmodule Volunteer.Listings do
  import Ecto.Query

  alias Volunteer.Repo
  alias Volunteer.Listings.Listing
  alias Volunteer.Listings.TKNListing
  alias Volunteer.Listings.MarketingRequest
  alias Volunteer.Accounts

  def new_listing do
    Listing.new()
  end

  def create_listing(attrs, created_by) do
    attrs
    |> Listing.create(created_by)
    |> Repo.insert()
  end

  def edit_listing(listing, attrs \\ %{}) do
    Listing.edit(listing, attrs)
  end

  def update_listing(listing, attrs \\ %{}) do
    listing
    |> edit_listing(attrs)
    |> Repo.update()
  end

  def delete_listing(listing) do
    Repo.delete(listing)
  end

  def approve_listing_if_not_expired!(listing, approved_by) do
    listing
    |> Listing.approve_if_not_expired(approved_by)
    |> Repo.update!()
  end

  def unapprove_listing_if_not_expired!(listing) do
    listing
    |> Listing.unapprove_if_not_expired()
    |> Repo.update!()
  end

  def expire_listing!(listing) do
    listing
    |> Listing.expire()
    |> Repo.update!()
  end

  def expiry_reminder_sent!(listing) do
    listing
    |> Listing.expiry_reminder_sent
    |> Repo.update!()
  end

  def refresh_and_maybe_unapprove_listing!(listing) do
    listing
    |> Listing.refresh_and_maybe_unapprove()
    |> Repo.update!()
  end

  def get_one_admin_listing!(id) do
    Repo.get!(Listing, id)
  end

  def get_all_admin_listings(opts \\ []) do
    filters = Keyword.get(opts, :filters)
    IO.inspect(filters)
    from(l in Listing)
    |> query_listings_with_filters(Keyword.get(opts, :filters))
    |> order_by(desc: :expiry_date)
    |> Repo.all()
  end

  def get_all_admin_listings_for_user(user, opts \\ []) do
    from(l in Listing)
    |> query_for_user_listing(user)
    |> query_listings_with_filters(Keyword.get(opts, :filters))
    |> order_by(desc: :expiry_date)
    |> Repo.all()
  end

  def get_all_public_listings do
    from(l in Listing)
    |> query_approved_listing()
    |> query_unexpired_listing()
    |> order_by(desc: :expiry_date)
    |> Repo.all()
  end

  def get_one_public_listing!(id) do
    from(l in Listing, where: l.id == ^id)
    |> query_approved_listing()
    |> query_unexpired_listing()
    |> Repo.one!()
  end

  def get_one_preview_listing!(id) do
    from(l in Listing, where: l.id == ^id)
    |> query_unexpired_listing()
    |> Repo.one!()
  end

  def get_all_listings_for_expiry_reminder(expiry_date) do
    from(l in Listing)
    |> query_unexpired_listing()
    |> query_listings_expiring_before(expiry_date)
    |> query_expiry_reminder_not_sent()
    |> Repo.all()
  end

  defp query_listings_with_filters(query, nil) do
    query
  end

  defp query_listings_with_filters(query, filters) when filters == %{} do
    query
  end

  defp query_listings_with_filters(query, %{approved: true, unapproved: true, expired: true}) do
    query
  end

  defp query_listings_with_filters(query, %{approved: false, unapproved: false, expired: false}) do
    from(l in query, where: fragment("1=0"))
  end

  defp query_listings_with_filters(query, %{approved: true, unapproved: false, expired: false}) do
    query_approved_listing(query)
    |> query_unexpired_listing()
  end

  defp query_listings_with_filters(query, %{approved: true, unapproved: true, expired: false}) do
    query_unexpired_listing(query)
  end

  defp query_listings_with_filters(query, %{approved: true, unapproved: false, expired: true}) do
    current_time = DateTime.utc_now()
    from(l in query,
      where: l.approved == true
          or l.expiry_date < ^current_time)
  end

  defp query_listings_with_filters(query, %{approved: false, unapproved: true, expired: false}) do
    query_unapproved_listing(query)
    |> query_unexpired_listing()
  end

  defp query_listings_with_filters(query, %{approved: false, unapproved: true, expired: true}) do
    current_time = DateTime.utc_now()
    from(l in query,
      where: l.approved == false
          or l.expiry_date < ^current_time)
  end

  defp query_listings_with_filters(query, %{approved: false, unapproved: false, expired: true}) do
    query_expired_listing(query)
  end

  defp query_for_user_listing(query, %Accounts.User{id: id} = user) do
    group_ids =
      Volunteer.Permissions.get_for_user(user, :group, ["admin"])
      |> Map.keys()

    region_ids =
      Volunteer.Permissions.get_for_user(user, :region, ["admin"])
      |> Map.keys()

    from(l in query,
      where: l.created_by_id == ^id
          or l.organized_by_id == ^id
          or l.group_id in ^group_ids
          or l.group_id in ^region_ids)
  end

  defp query_approved_listing(query) do
    from(l in query, where: l.approved == true)
  end

  defp query_unapproved_listing(query) do
    from(l in query, where: l.approved == false)
  end

  defp query_expired_listing(query) do
    current_time = DateTime.utc_now()
    from(l in query, where: l.expiry_date < ^current_time)
  end

  defp query_unexpired_listing(query) do
    current_time = DateTime.utc_now()
    from(l in query, where: l.expiry_date >= ^current_time)
  end

  def query_listings_expiring_before(query, expiry_date) do
    from(l in query, where: l.expiry_date <= ^expiry_date)
  end

  def query_expiry_reminder_not_sent(query) do
    from(l in query, where: l.expiry_reminder_sent == false)
  end

  def new_tkn_listing() do
    TKNListing.changeset(%TKNListing{}, %{})
  end

  def create_tkn_listing(listing, attrs) do
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

  def get_one_tkn_listing!(id) do
    Repo.get!(TKNListing, id)
  end

  def get_one_tkn_listing(id) do
    Repo.get(TKNListing, id)
  end

  def delete_tkn_listing(tkn_listing) do
    Repo.delete(tkn_listing)
  end

  def get_one_tkn_listing_for_listing!(id) do
    query_tkn_listing_for_listing(id)
    |> Repo.one!()
  end

  def get_one_tkn_listing_for_listing(id) do
    query_tkn_listing_for_listing(id)
    |> Repo.one()
  end

  defp query_tkn_listing_for_listing(id) do
    from(l in TKNListing, where: l.listing_id == ^id)
  end

  def new_marketing_request(listing) do
    MarketingRequest.new(
      MarketingRequest.default_channels(),
      %{listing: listing}
    )
  end

  def create_marketing_request(listing, attrs) do
    MarketingRequest.create(
      MarketingRequest.default_channels(),
      %{listing: listing},
      attrs
    )
  end

  def send_marketing_request(listing, attrs) do
    case create_marketing_request(listing, attrs) do
      %{valid?: true} = changeset ->
        email =
          changeset
          |> Ecto.Changeset.apply_changes()
          |> VolunteerEmail.ListingsEmails.marketing_request(listing)
          |> VolunteerEmail.Mailer.deliver_now()

        {:ok, email}

      %{valid?: false} = changeset ->
        {:error, changeset}
    end
  end
end
