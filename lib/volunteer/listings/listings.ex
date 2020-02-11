defmodule Volunteer.Listings do
  import Ecto.Query
  alias Volunteer.Repo
  alias Volunteer.Logs
  alias Volunteer.Roles
  alias Volunteer.Listings.Change
  alias Volunteer.Listings.Listing
  alias Volunteer.Listings.Public

  def new do
    Change.new()
  end

  def create(attrs, created_by) do
    Ecto.Multi.new
    |> Ecto.Multi.insert(:create, Change.create(attrs, created_by))
    |> Ecto.Multi.run(:role, fn repo, %{create: listing} ->
      Roles.create(:listing, listing.id, %{user_id: created_by.id, relation: "admin"}, nil, repo)
    end)
    |> Ecto.Multi.run(:log, fn repo, %{create: listing} ->
      Logs.create(%{
        action: [:admin, :listing, :create],
        actor: created_by,
        listing: listing
      }, repo)
    end)
    |> Repo.transaction
  end

  def edit(listing, attrs \\ %{}) do
    Change.edit(listing, attrs)
  end

  def update(listing, attrs, updated_by) do
    Ecto.Multi.new
    |> Ecto.Multi.update(:update, edit(listing, attrs))
    |> Logs.create(%{
        action: [:admin, :listing, :update],
        actor: updated_by,
        listing: listing
      })
    |> Repo.transaction
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
