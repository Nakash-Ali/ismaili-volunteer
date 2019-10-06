defmodule Volunteer.Accounts do
  import Ecto.Query

  alias Volunteer.Repo
  alias Volunteer.Accounts.User
  alias Volunteer.Accounts.Identity

  @primary_email_admin_domain "iicanada.net"

  def upsert_authenticated_user(%{provider: provider, provider_id: provider_id} = attrs) do
    Repo.transaction(fn ->
      case get_identity_and_user(provider, provider_id) do
        nil ->
          user = User.changeset_authenticated(attrs) |> Repo.insert!()
          create_identity!(attrs, user)
          user

        identity ->
          User.changeset_authenticated(identity.user, attrs) |> Repo.update!()
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

  def create_or_update_user(attrs) do
    changeset = User.changeset(attrs)
    case Repo.insert(changeset, User.upsert_opts()) do
      {:ok, user} ->
        {:ok, user, changeset}

      {:error, _} = error ->
        error
    end
  end

  def create_identity!(attrs, user) do
    %Identity{}
    |> Identity.changeset(attrs, user)
    |> Repo.insert!()
  end

  def new_user() do
    User.changeset(%{})
  end

  def create_user!(attrs) do
    User.changeset(attrs) |> Repo.insert!()
  end

  def create_user(attrs) do
    User.changeset(attrs) |> Repo.insert()
  end

  def get_user!(id) do
    User |> Repo.get!(id)
  end

  def get_user(id) do
    User |> Repo.get(id)
  end

  def get_user_for_session(id) do
    get_user(id)
    |> Repo.preload(:roles)
  end

  def get_admin_user_id_choices do
    from(
      u in User,
      select: {u.title, u.id},
      where: ilike(u.primary_email, ^"%#{@primary_email_admin_domain}")
    )
    |> order_by(asc: :title)
    |> Repo.all()
  end

  def get_all_users do
    from(u in User, select: u)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def get_user_by_primary_email(primary_email) do
    from(u in User, where: u.primary_email == ^primary_email)
    |> Repo.one()
  end
end
