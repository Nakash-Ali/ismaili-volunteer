defmodule Volunteer.Logs.Log do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Accounts.User
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Infrastructure.Group
  alias Volunteer.Listings.Listing
  alias Volunteer.Apply.Applicant

  # TODO: use this to capture real things that aren't stored anywhere else:
  #   - approval requests
  #   - approve/unapprove
  #   - expiry reminder sent
  #   - marketing request sent
  #   - tkn assignment spec sent

  schema "logs" do
    belongs_to :actor, User

    field :action, Volunteer.Permissions.Actions.Type
    field :context, :map, default: %{}
    field :occured_at, :utc_datetime, autogenerate: {Ecto.Schema, :__timestamps__, [:utc_datetime]}

    belongs_to :region, Region
    belongs_to :group, Group
    belongs_to :listing, Listing
    belongs_to :applicant, Applicant

    timestamps()
  end

  def create(opts) do
    %__MODULE__{}
    |> cast(opts, [:actor_id, :action, :context, :occured_at, :region_id, :group_id, :listing_id, :applicant_id])
    |> cast_assoc_id(:actor, opts)
    |> cast_assoc_id(:region, opts)
    |> cast_assoc_id(:group, opts)
    |> cast_assoc_id(:listing, opts)
    |> cast_assoc_id(:applicant, opts)
    |> foreign_key_constraint(:actor)
    |> foreign_key_constraint(:region)
    |> foreign_key_constraint(:group)
    |> foreign_key_constraint(:listing)
    |> foreign_key_constraint(:applicant)
    |> validate_required([:action])
    |> validate_inclusion(:action, Volunteer.Permissions.Actions.actions_list)
  end

  defp cast_assoc_id(changeset, field, opts) do
    case Map.fetch(opts, field) do
      {:ok, nil} ->
        cast(changeset, %{:"#{field}_id" => nil}, [:"#{field}_id"])

      {:ok, %{id: id}} ->
        cast(changeset, %{:"#{field}_id" => id}, [:"#{field}_id"])

      :error ->
        changeset
    end
  end
end
