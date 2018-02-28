defmodule Volunteer.Apply.Listing do
  use Volunteer, :schema
  use Timex
  import Ecto.Changeset
  import Ecto.Query, only: [from: 1, from: 2]
  alias Volunteer.Apply.Listing
  alias Volunteer.Apply.TKNListing
  alias Volunteer.Infrastructure.Group
  alias Volunteer.Accounts.User


  schema "listings" do
    field :expiry_date, :date

    field :approved, :boolean, default: false
    field :approved_on, :utc_datetime
    belongs_to :approved_by, User

    field :title, :string
    field :program_title, :string
    field :summary_line, :string
    belongs_to :group, Group
    belongs_to :organizer, User

    field :start_date, :date
    field :end_date, :date
    field :hours_per_week, :decimal

    field :program_description, :string
    field :responsibilities, :string
    field :qualifications, :string

    field :tkn_eligible, :boolean, default: false
    has_one :tkn_listing, TKNListing

    # TODO: CC'ed users
    # TODO: other attached users

    timestamps()
  end

  def changeset(listing \\ %Listing{}, attrs \\ %{}, group \\ nil, organizer \\ nil)

  def changeset(listing, attrs, %Group{} = group, organizer) do
    attrs = Map.put(attrs, :group_id, group.id)
    changeset(listing, attrs, nil, organizer)
  end

  def changeset(listing, attrs, group_id, organizer) when is_integer(group_id) do
    attrs = Map.put(attrs, :group_id, group_id)
    changeset(listing, attrs, nil, organizer)
  end

  def changeset(listing, attrs, group, %User{} = organizer) do
    attrs = Map.put(attrs, :organizer_id, organizer.id)
    changeset(listing, attrs, group, nil)
  end

  def changeset(listing, attrs, group, organizer_id) when is_integer(organizer_id) do
    attrs = Map.put(attrs, :organizer_id, organizer_id)
    changeset(listing, attrs, group, nil)
  end

  def changeset(%Listing{} = listing, attrs, _, _) do
    listing
    |> cast(attrs, [
      :title,
      :program_title,
      :summary_line,
      :group_id,
      :organizer_id,
      :start_date,
      :end_date,
      :hours_per_week,
      :program_description,
      :responsibilities,
      :qualifications,
      :tkn_eligible,
      ])
    |> validate_required([
      :title,
      :program_title,
      :summary_line,
      :group_id,
      :organizer_id,
      :hours_per_week,
      :program_description,
      :responsibilities,
      :qualifications,
      :tkn_eligible,
      ])
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:organizer_id)
    |> validate_length(:summary_line, max: 140)
    |> cast_assoc(:tkn_listing)
    |> refresh_expiry
  end

  def approve(%Listing{approved: false} = listing, %User{} = approved_by) do
    listing
    |> change(%{approved: true, approved_on: Timex.now})
    |> put_assoc(:approved_by, approved_by)
    |> foreign_key_constraint(:approved_by_id)
  end

  def refresh_expiry(listing) do
    listing |> change(%{expiry_date: refreshed_expiry_date()})
  end

  def refreshed_expiry_date() do
    Timex.now |> Timex.shift(days: 14) |> Timex.to_date
  end

  def query_all do
    from l in Listing
  end

  def query_filter_for_organizer(query, user) do
    from l in query,
      where: l.organizer_id == ^user.id
  end

end
