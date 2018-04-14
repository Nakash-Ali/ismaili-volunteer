defmodule Volunteer.Permissions.Role do
  use Ecto.Schema
  import Ecto.Changeset
  alias Volunteer.Permissions.Role
  alias Volunteer.Accounts.User
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Infrastructure.Group

  schema "roles" do
    field :type, :string
    belongs_to :group, Group
    belongs_to :region, Region
    belongs_to :user, User

    timestamps()
  end

  @role_types [
    :superadmin,
    :admin,
    :organizer
  ]

  @attributes_cast_always [
    :type,
    :user_id
  ]

  @attributes_required_always [
    :type,
    :user_id
  ]

  def types do
    @role_types
  end

  def create(role, %User{} = user, type) when role == %Role{} and type in @role_types do
    create(role, %{
      type: type,
      user_id: user.id
    })
  end

  def create(role, attrs) when role == %Role{} and is_map(attrs) do
    role
    |> cast(attrs, @attributes_cast_always)
    |> validate_required(@attributes_required_always)
    |> common_changeset_funcs
  end

  def common_changeset_funcs(changeset) do
    changeset
    |> validate_inclusion(:type, [@role_types])
    |> foreign_key_constraint(:group_id)
    |> foreign_key_constraint(:region_id)
    |> foreign_key_constraint(:user_id)

    # |> unique_constraint
  end
end
