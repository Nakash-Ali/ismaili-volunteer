defmodule Volunteer.Apply do
  import Ecto.Query

  alias Volunteer.Repo
  alias Volunteer.Apply.Applicant
  alias Volunteer.Accounts

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
