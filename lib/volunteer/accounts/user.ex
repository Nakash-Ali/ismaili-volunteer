defmodule Volunteer.Accounts.User do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Accounts.User
  alias Volunteer.Accounts.Identity


  schema "users" do
    field :title, :string
    field :given_name, :string
    field :sur_name, :string

    field :primary_email, :string
    field :primary_phone, :string

    field :is_admin, :boolean, default: false

    has_many :identities, Identity

    timestamps()
  end

  def changeset(user \\ %User{}, attrs \\ %{})

  def changeset(user, attrs) when user == %User{} do
    user
    |> cast(attrs, [:title, :given_name, :sur_name, :primary_email, :primary_phone])
    |> validate_required([:title, :given_name, :sur_name, :primary_email])
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:title, :given_name, :sur_name, :primary_email, :primary_phone])
  end

  def to_admin(user) do
    user |> change(%{is_admin: true})
  end

  def to_non_admin(user) do
    user |> change(%{is_admin: false})
  end
  
  def get_title(user) do
    user.title
  end
end
