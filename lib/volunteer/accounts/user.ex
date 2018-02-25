defmodule Volunteer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Volunteer.Accounts.User
  alias Volunteer.Accounts.Identity

  schema "users" do
    field :title, :string
    field :given_name, :string
    field :sur_name, :string
    field :primary_email, :string
    field :is_admin, :boolean, default: false

    has_many :identities, Identity

    timestamps()
  end

  def changeset(user \\ %User{}, attrs \\ %{})

  def changeset(user, attrs) when user == %User{} do
    user
    |> cast(attrs, [:title, :primary_email, :given_name, :sur_name])
    |> validate_required([:title, :primary_email, :given_name, :sur_name])
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:title, :primary_email, :given_name, :sur_name])
  end

  def to_admin(user) do
    user
    |> changeset(%{is_admin: true})
  end

  def to_non_admin(user) do
    user
    |> changeset(%{is_admin: false})
  end
end
