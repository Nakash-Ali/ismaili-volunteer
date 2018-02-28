defmodule Volunteer.Accounts.Identity do
  use Volunteer, :schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 1, from: 2]
  alias Volunteer.Accounts.Identity
  alias Volunteer.Accounts.User


  schema "identities" do
    field :provider, :string
    field :provider_id, :string

    belongs_to :user, User

    timestamps()
  end

  def changeset(identity \\ %Identity{}, attrs \\ %{}, user \\ nil)

  def changeset(identity, attrs, user_id) when is_integer(user_id) do
    attrs = Map.put(attrs, :user_id, user_id)
    changeset(identity, attrs, nil)
  end

  def changeset(identity, attrs, user) when identity == %Identity{} do
    case user do
      nil ->
        identity
        |> cast(attrs, [:provider, :provider_id, :user_id])
        |> validate_required([:provider, :provider_id, :user_id])
      %User{} ->
        identity
        |> cast(attrs, [:provider, :provider_id])
        |> validate_required([:provider, :provider_id])
        |> put_assoc(:user, user)
    end
    |> unique_constraint(:provider_id, name: :identities_provider_provider_id_index)
    |> foreign_key_constraint(:user_id)
  end

  def query_all do
    from i in Identity
  end

  def query_filter_by_provider_and_provider_id(query, provider, provider_id) do
    from i in query,
      where: i.provider == ^provider and i.provider_id == ^provider_id
  end

  def query_include_user(query) do
    from i in query,
      join: u in assoc(i, :user),
      preload: [user: u]
  end

end
