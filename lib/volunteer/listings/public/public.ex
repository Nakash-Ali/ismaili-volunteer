defmodule Volunteer.Listings.Public do
  import Ecto.Query
  alias Volunteer.Repo
  alias Volunteer.Logs
  alias VolunteerEmail.Mailer
  alias Volunteer.Listings.InfraFilters
  alias Volunteer.Listings.Public.Change
  alias Volunteer.Listings.Public.Filters

  # TODO: Use logs to derive state instead of persisting it with model

  def reset(listing, reset_by) do
    Ecto.Multi.new
    # TODO: Does this needs the same treatment as `refresh/1`
    # to guarantee that invariants are upheld?
    |> Ecto.Multi.update(:reset, Change.reset(listing))
    |> Logs.create(%{
        action: [:admin, :listing, :public, :reset],
        actor: reset_by,
        listing: listing
      })
    |> Repo.transaction
  end

  def request_approval(listing, requested_by) do
    Ecto.Multi.new
    # TODO: Does this needs the same treatment as `refresh/1`
    # to guarantee that invariants are upheld?
    |> Mailer.deliver(:request_approval, fn _repo, _prev ->
      VolunteerEmail.ListingsEmails.request_approval(listing, requested_by)
    end)
    |> Logs.create(%{
        action: [:admin, :listing, :public, :request_approval],
        actor: requested_by,
        listing: listing
      })
    |> Repo.transaction
  end

  def approve(listing, approved_by) do
    Ecto.Multi.new
    # TODO: Does this needs the same treatment as `refresh/1`
    # to guarantee that invariants are upheld?
    |> Ecto.Multi.update(:approve, Change.approve(listing, approved_by))
    |> Mailer.deliver(:on_approval, fn _repo, %{approve: approved_listing} ->
      VolunteerEmail.ListingsEmails.on_approval(approved_listing, approved_by)
    end)
    |> Logs.create(%{
        action: [:admin, :listing, :public, :approve],
        actor: approved_by,
        listing: listing
      })
    |> Repo.transaction
  end

  def unapprove(listing, unapproved_by) do
    Ecto.Multi.new
    # TODO: Does this needs the same treatment as `refresh/1`
    # to guarantee that invariants are upheld?
    |> Ecto.Multi.update(:unapprove, Change.unapprove(listing))
    |> Mailer.deliver(:on_unapproval, fn _repo, %{unapprove: unapproved_listing} ->
      VolunteerEmail.ListingsEmails.on_unapproval(unapproved_listing, unapproved_by)
    end)
    |> Logs.create(%{
        action: [:admin, :listing, :public, :unapprove],
        actor: unapproved_by,
        listing: listing
      })
    |> Repo.transaction
  end

  def expire(listing, expired_by) do
    Ecto.Multi.new
    # TODO: Does this needs the same treatment as `refresh/1`
    # to guarantee that invariants are upheld?
    |> Ecto.Multi.update(:expire, Change.expire(listing))
    |> Logs.create(%{
        action: [:admin, :listing, :public, :expire],
        actor: expired_by,
        listing: listing
      })
    |> Repo.transaction
  end

  def expiry_reminder_sent(listing) do
    Ecto.Multi.new
    # TODO: Does this needs the same treatment as `refresh/1`
    # to guarantee that invariants are upheld?
    |> Ecto.Multi.update(:expiry_reminder, Change.expiry_reminder_sent(listing))
    |> Logs.create(%{
        action: [:admin, :listing, :public, :expiry_reminder],
        listing: listing
      })
    |> Repo.transaction
  end

  # NOTE: Only listings that are approved and not expired can be refreshed.
  # This constraint is expressed in the update query and preserved in the
  # database, to prevent against double-writes. We could also use the
  # SERIALIZABLE transaction isolation level to guard against this, but we'd
  # need to fetch the listing again inside the transaction (and not use the
  # listing object that's been passed to us).
  def refresh(listing, refreshed_by) do
    Ecto.Multi.new
    |> Ecto.Multi.run(:refresh, fn repo, _prev ->
      case Change.refresh(listing) do
        %{valid?: true, changes: changes} ->
          from(l in Volunteer.Listings.base_query())
          |> where(id: ^listing.id)
          |> Filters.approved()
          |> Filters.unexpired()
          |> update(set: ^Enum.into(changes, []))
          |> repo.update_all([])
          |> case do
            {1, [listing]} ->
              {:ok, listing}

            result ->
              IO.inspect(result)
              {:error, :broken_invariant}
          end

        %{valid?: false} = changeset ->
          {:error, changeset}
      end
    end)
    |> Logs.create(%{
        action: [:admin, :listing, :public, :refresh],
        actor: refreshed_by,
        listing: listing
      })
    |> Repo.transaction
  end

  def get_all(opts \\ []) do
    from(l in Volunteer.Listings.base_query())
    |> Filters.approved()
    |> Filters.unexpired()
    |> InfraFilters.by_region(Keyword.get(opts, :filters, %{}))
    |> InfraFilters.by_group(Keyword.get(opts, :filters, %{}))
    |> order_by(desc: :public_expiry_date)
    |> Repo.all()
  end

  def get_one!(id, allow_expired: allow_expired) do
    query =
      from(l in Volunteer.Listings.base_query(), where: l.id == ^id)
      |> Filters.approved()

    if allow_expired do
      query
    else
      query
      |> Filters.unexpired()
    end
    |> Repo.one!()
  end

  def get_one_for_preview!(id) do
    from(l in Volunteer.Listings.base_query(), where: l.id == ^id)
    |> Repo.one!()
  end

  def get_all_for_expiry_reminder(expiry_date) do
    from(l in Volunteer.Listings.base_query())
    |> Filters.approved()
    |> Filters.unexpired()
    |> Filters.expiring_before(expiry_date)
    |> Filters.expiry_reminder_not_sent()
    |> Repo.all()
  end
end
