defmodule Volunteer.Apply do
  import Ecto.Query

  alias Volunteer.Repo
  alias Volunteer.Apply.Applicant
  alias Volunteer.Listings.Listing
  alias Volunteer.Accounts

  def new_applicant() do
    Applicant.create(%{}, nil, nil)
  end

  def create_applicant(attrs, listing, user) do
    Applicant.create(attrs, listing, user) |> Repo.insert()
  end

  def update_applicant(applicant, attrs, listing, user) do
    Applicant.update(applicant, attrs, listing, user) |> Repo.update()
  end

  def create_or_update_applicant(attrs, listing, user) do
    get_applicant_by_listing_and_user(listing.id, user.id)
    |> case do
      nil ->
        create_applicant(attrs, listing, user)

      applicant ->
        update_applicant(applicant, attrs, listing, user)
    end
  end

  def new_applicant_with_user() do
    {Accounts.new_user(), new_applicant()}
  end

  def create_or_update_applicant_with_user(%Listing{} = listing, user_attrs, applicant_attrs) do
    Repo.transaction(fn ->
      case Accounts.create_or_update_user(user_attrs) do
        {:error, user_changeset} ->
          {:error, applicant_changeset} = create_applicant(applicant_attrs, listing, nil)
          Repo.rollback({user_changeset, applicant_changeset})

        {:ok, user, user_changeset} ->
          case create_or_update_applicant(applicant_attrs, listing, user) do
            {:error, applicant_changeset} ->
              Repo.rollback({user_changeset, applicant_changeset})

            {:ok, applicant} ->
              send_on_applicant_emails!(listing, user, applicant)
              {user, applicant}
          end
      end
    end)
  end

  defp send_on_applicant_emails!(listing, user, applicant) do
    [
      &VolunteerEmail.ListingsEmails.on_applicant_external/3,
      &VolunteerEmail.ListingsEmails.on_applicant_internal/3,
    ]
    |> Enum.map(& &1.(listing, user, applicant))
    |> Enum.map(&VolunteerEmail.Mailer.deliver_now!/1)
  end

  def get_all_applicants_by_listing(%Listing{id: listing_id}) do
    get_all_applicants_by_listing(listing_id)
  end

  def get_all_applicants_by_listing(listing_id) do
    from(a in Applicant, where: a.listing_id == ^listing_id)
    |> order_by(desc: :updated_at)
    |> Repo.all()
  end

  def get_applicant_by_listing_and_user(listing_id, user_id) do
    from(a in Applicant, where: a.listing_id == ^listing_id and a.user_id == ^user_id)
    |> Repo.one()
  end

  def get_applicant_by_opaque_id!(opaque_id) do
    from(a in Applicant, where: a.opaque_id == ^opaque_id)
    |> Repo.one!()
    |> Repo.preload([:user, :listing])
  end

  def annotate(applicants, options) when is_list(applicants) do
    Enum.map(applicants, &annotate(&1, options))
  end

  def annotate(%Applicant{} = applicant, options) do
    Enum.reduce(options, applicant, fn
      {:user, user_options}, applicant ->
        Map.update!(
          applicant,
          :user,
          &Accounts.annotate(&1, user_options)
        )
    end)
  end
end
