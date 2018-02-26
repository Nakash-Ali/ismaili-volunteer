defmodule Volunteer.Apply.Listing do
  use Volunteer, :schema
  use Timex
  import Ecto.Changeset
  alias Volunteer.Apply.Listing
  alias Volunteer.Apply.TKNListing
  alias Volunteer.Infrastructure.Group
  alias Volunteer.Accounts.User


  schema "listings" do
    field :expiry_date, :date

    field :approved, :boolean, default: false
    field :approved_by, :id
    field :approved_on, :utc_datetime

    field :title, :string
    field :program_title, :string
    field :summary_line, :string
    belongs_to :group, Group
    belongs_to :organizing_user, User

    field :start_date, :date
    field :end_date, :date
    field :hours_per_week, :decimal
    field :commitments, :string

    field :program_description, :string
    field :responsibilities, :string
    field :qualifications, :string
    field :pro_qualifications, :boolean, default: false

    field :tkn_eligible, :boolean, default: false
    belongs_to :tkn_listing, TKNListing

    # TODO: CC'ed users
    # TODO: other attached users

    timestamps()
  end

  def changeset(%Listing{} = listing, attrs) do
    listing
    |> cast(attrs, [
      :approved,
      :approved_by_id,
      :approved_date,
      :title,
      :program_title,
      :summary_line,
      :group_id,
      :organizing_user_id,
      :start_date,
      :end_date,
      :hours_per_week,
      :commitments,
      :program_description,
      :responsibilities,
      :qualifications,
      :pro_qualifications,
      :tkn_eligible,
      ])
    |> validate_required([
      :approved,
      :title,
      :program_title,
      :summary_line,
      :group_id,
      :organizing_user_id,
      :hours_per_week,
      :program_description,
      :responsibilities,
      :qualifications,
      :pro_qualifications,
      :tkn_eligible,
      ])
    |> validate_length(:summary_line, max: 140)
    |> validate_if_approved
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:organizing_user_id)
    |> refresh_expiry
    |> cast_assoc(:tkn_listing)
  end

  def validate_if_approved(changeset) do
    case fetch_change(changeset, :approved) do
      false -> changeset
      true ->
        changeset
        |> validate_required([:approved_by_id, :approved_on])
        |> foreign_key_constraint(:approved_by_id)
    end
  end

  def refresh_expiry(listing) do
    listing |> change(%{ expiry_date: refreshed_expiry_date() })
  end

  def refreshed_expiry_date() do
    Timex.now |> Timex.shift(days: 14) |> Timex.to_date
  end

end
