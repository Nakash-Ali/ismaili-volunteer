defmodule Volunteer.Apply do
  import Ecto.Query

  alias Volunteer.Repo
  alias Volunteer.Apply.Listing
  alias Volunteer.Apply.TKNListing
  alias Volunteer.Apply.MarketingRequest
  alias Volunteer.Apply.Applicant
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

  def refresh_and_maybe_unapprove_listing!(listing) do
    listing
    |> Listing.refresh_and_maybe_unapprove()
    |> Repo.update!()
  end

  def get_one_admin_listing!(id) do
    Repo.get!(Listing, id)
  end

  def get_all_admin_listings do
    from(l in Listing)
    |> Repo.all()
  end

  def get_all_admin_listings_for_user(user) do
    from(l in Listing)
    |> query_for_user_listing(user)
    |> Repo.all()
  end

  def get_all_public_listings do
    from(l in Listing)
    |> query_approved_listing
    |> query_unexpired_listing
    |> Repo.all()
  end

  def get_one_public_listing!(id) do
    from(l in Listing, where: l.id == ^id)
    |> query_approved_listing
    |> query_unexpired_listing
    |> Repo.one!()
  end

  def get_one_preview_listing!(id) do
    from(l in Listing, where: l.id == ^id)
    |> query_unexpired_listing
    |> Repo.one!()
  end

  defp query_for_user_listing(query, %Accounts.User{id: id}) do
    from(l in query, where: l.created_by_id == ^id or l.organized_by_id == ^id)
  end

  defp query_approved_listing(query) do
    from(l in query, where: l.approved == true)
  end

  defp query_unexpired_listing(query) do
    current_time = DateTime.utc_now()
    from(l in query, where: l.expiry_date >= ^current_time)
  end

  defp query_unended_listing(query) do
    current_date = Date.utc_today()
    from(l in query, where: l.end_date >= ^current_date or is_nil(l.end_date))
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
          |> VolunteerEmail.ApplyEmails.marketing_request(listing)
          |> VolunteerEmail.Mailer.deliver_now()

        {:ok, email}

      %{valid?: false} = changeset ->
        {:error, changeset}
    end
  end

  def new_applicant() do
    %Applicant{}
    |> Applicant.changeset(%{})
  end

  def create_applicant(attrs) do
    %Applicant{}
    |> Applicant.changeset(attrs)
    |> Repo.insert()
  end

  def new_applicant_with_user() do
    {Accounts.new_user(), new_applicant()}
  end

  def create_applicant_with_user(listing, user_attrs, applicant_attrs) do
    create_applicant_with_user(
      user_attrs,
      Map.put(applicant_attrs, "listing_id", listing.id)
    )
  end

  def create_applicant_with_user(user_attrs, applicant_attrs) do
    Repo.transaction(fn ->
      user_changeset = Accounts.User.changeset(%Accounts.User{}, user_attrs)

      case Repo.insert(user_changeset) do
        {:error, user_changeset} ->
          {:error, applicant_changeset} = create_applicant(applicant_attrs)
          Repo.rollback({user_changeset, applicant_changeset})

        {:ok, user} ->
          applicant_attrs
          |> Map.put("user_id", user.id)
          |> create_applicant
          |> case do
            {:error, applicant_changeset} ->
              Repo.rollback({user_changeset, applicant_changeset})

            {:ok, applicant} ->
              {:ok, {user, applicant}}
          end
      end
    end)
  end

  def get_all_applicants() do
    from(a in Applicant)
    |> Repo.all()
  end
end
