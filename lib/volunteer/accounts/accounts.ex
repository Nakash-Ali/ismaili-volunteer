defmodule Volunteer.Accounts do

  import Ecto.Query, warn: false
  alias Volunteer.Repo

  alias Volunteer.Accounts.User
  alias Volunteer.Accounts.Identity

  def upsert_together_and_return(%{provider: provider, provider_id: provider_id} = attrs) do
    Repo.transaction(fn ->
      case get_identity_with_user(provider, provider_id) do
        nil -> (
          user = create_user!(attrs)
          create_identity!(attrs, user)
          user
        )
        identity -> (
          update_user!(identity.user, attrs)
        )
      end
    end)
  end

  def get_identity_with_user(provider, provider_id) do
    from(i in Identity)
    |> Identity.filter_by_provider_and_provider_id(provider, provider_id)
    |> Identity.inner_join_user
    |> Repo.one
  end

  def create_identity!(attrs, user) do
    %Identity{}
    |> Identity.changeset(attrs, user)
    |> Repo.insert!()
  end

  def create_user!(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!(returning: [:id])
  end

  def update_user!(user, attrs \\ %{}) do
    user
    |> User.changeset(attrs)
    |> Repo.update!()
  end

end
