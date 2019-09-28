defmodule Volunteer.Roles.Role do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Accounts.User
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Infrastructure.Group
  alias Volunteer.Listings.Listing

  schema "roles" do
    field :relation, :string
    belongs_to :user, User

    belongs_to :group, Group
    belongs_to :region, Region
    belongs_to :listing, Listing

    timestamps()
  end

  @config_by_subject_type %{
    group: %{
      relations: ["admin"],
      module: Volunteer.Infrastructure.Group
    },
    region: %{
      relations: ["admin", "cc_team"],
      module: Volunteer.Infrastructure.Region
    },
    listing: %{
      relations: ["admin", "read-only"],
      module: Volunteer.Listings.Listing
    }
  }

  @subject_types @config_by_subject_type |> Map.keys

  @attributes_cast_always [
    :relation,
    :user_id,
  ]

  @attributes_required_always [
    :relation,
    :user_id,
  ]

  def config_by_subject_type() do
    @config_by_subject_type
  end

  def subject_types() do
    @subject_types
  end

  def disambiguate_role(%{group_id: subject_id, region_id: nil, listing_id: nil}) when is_integer(subject_id) do
    {:group, subject_id}
  end

  def disambiguate_role(%{group_id: nil, region_id: subject_id, listing_id: nil}) when is_integer(subject_id) do
    {:region, subject_id}
  end

  def disambiguate_role(%{group_id: nil, region_id: nil, listing_id: subject_id}) when is_integer(subject_id) do
    {:listing, subject_id}
  end

  def config_for_subject_type(subject_type, key) when subject_type in @subject_types do
    @config_by_subject_type
    |> Map.fetch!(subject_type)
    |> Map.fetch!(key)
  end

  def new(subject_type, subject_id) do
    create(subject_type, subject_id, %{})
  end

  def create(subject_type, subject_id, attrs) when subject_type in @subject_types do
    %__MODULE__{}
    |> cast(attrs, @attributes_cast_always)
    |> cast(%{"#{subject_type}_id": subject_id}, [:"#{subject_type}_id"])
    |> validate_required(@attributes_required_always)
    |> validate_at_least_one_subject
    |> validate_all_subject_types
    |> validate_relation_for_subject_type(subject_type)
    |> foreign_key_constraint(:user_id)
    |> check_constraint(
      :_exclusive_arc,
      name: :exclusive_arc,
      message: "A role cannot be associated with multiple subjects."
    )
  end

  # TODO: implement this
  def validate_at_least_one_subject(changeset) do
    changeset
  end

  def validate_all_subject_types(changeset) do
    Enum.reduce(@subject_types, changeset, &validate_all_subject_types(&2, &1))
  end

  def validate_all_subject_types(changeset, subject_type) do
    changeset
    |> foreign_key_constraint(:"#{subject_type}_id")
    |> unique_constraint(
      :_unique_relation,
      name: "roles_user_id_#{subject_type}_id_not_null_unique",
      message: "This user has already been assigned a role for this #{subject_type}. Please delete that first before creating a new one."
    )
  end

  def validate_relation_for_subject_type(changeset, subject_type) do
    case fetch_field(changeset, :"#{subject_type}_id") do
      {_source, value} when not is_nil(value) ->
        validate_inclusion(changeset, :relation, config_for_subject_type(subject_type, :relations))

      _ ->
        changeset
    end
  end
end
