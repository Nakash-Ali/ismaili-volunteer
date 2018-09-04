defmodule Volunteer.Accounts do
  import Ecto.Query, only: [from: 2]

  alias Volunteer.Repo
  alias Volunteer.Accounts.User
  alias Volunteer.Accounts.Identity

  def upsert_together_and_return(%{provider: provider, provider_id: provider_id} = attrs) do
    Repo.transaction(fn ->
      case get_identity_and_user(provider, provider_id) do
        nil ->
          user = create_user!(attrs)
          create_identity!(attrs, user)
          user

        identity ->
          update_user!(identity.user, attrs)
      end
    end)
  end

  def get_identity_and_user(provider, provider_id) do
    from(
      i in Identity,
      where: i.provider == ^provider and i.provider_id == ^provider_id,
      join: u in assoc(i, :user),
      preload: [user: u]
    )
    |> Repo.one()
  end

  def create_identity!(attrs, user) do
    %Identity{}
    |> Identity.changeset(attrs, user)
    |> Repo.insert!()
  end

  def new_user() do
    %User{}
    |> User.changeset(%{})
  end

  def create_user!(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!()
  end

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user!(user, attrs \\ %{}) do
    user
    |> User.changeset(attrs)
    |> Repo.update!()
  end

  def get_user!(id) do
    User |> Repo.get!(id)
  end

  def get_user(id) do
    User |> Repo.get(id)
  end

  def get_user_id_choices do
    from(
      u in User,
      select: {u.title, u.id}
    )
    |> Repo.all()
  end
end
