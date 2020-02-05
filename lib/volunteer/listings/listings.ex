defmodule Volunteer.Listings do
  import Ecto.Query
  alias Volunteer.Repo
  alias Volunteer.Roles
  alias Volunteer.Listings.Change
  alias Volunteer.Listings.Listing
  alias Volunteer.Listings.Public

  def new do
    Change.new()
  end

  def create(attrs, created_by) do
    Repo.transaction(fn ->
      attrs
      |> Change.create(created_by)
      |> Repo.insert()
      |> case do
        {:ok, listing} ->
          Roles.create_roles_for_new_listing!(listing)

          listing

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  def edit(listing, attrs \\ %{}) do
    Change.edit(listing, attrs)
  end

  def update(listing, attrs \\ %{}) do
    listing
    |> edit(attrs)
    |> Repo.update()
  end

  def delete(listing) do
    Repo.delete(listing)
  end

  def preloadables() do
    [:created_by, :public_approved_by, :region, :group, :organized_by]
  end

  def base_query() do
    from(l in Listing, select_merge: %{
      start_date_toggle: is_nil(l.start_date),
      end_date_toggle: is_nil(l.end_date),
    })
  end

  def get_one_admin!(id) do
    from(l in base_query(),
      where: l.id == ^id)
    |> Repo.one!
  end

  # TODO: paginate with https://github.com/duffelhq/paginator
  # Since listing IDs are sequential, using them is guaranteed to sort by
  # `created_at` without any consistency issues of duplicates or missed rows
  def get_all_admin(opts \\ []) do
    from(l in base_query())
    |> Public.AdminStateFilters.filter(Keyword.get(opts, :filters, %{}))
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end
end
