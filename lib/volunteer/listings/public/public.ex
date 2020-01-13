defmodule Volunteer.Listings.Public do
  import Ecto.Query
  alias Volunteer.Repo
  alias Volunteer.Listings.InfraFilters
  alias Volunteer.Listings.Public.Change
  alias Volunteer.Listings.Public.Filters

  # TODO: This needs the same transactionality treatment as `refresh/1`
  def reset!(listing) do
    listing
    |> Change.reset()
    |> Repo.update!()
  end

  # TODO: This needs the same transactionality treatment as `refresh/1`
  def request_approval!(listing, requested_by) do
    listing
    |> VolunteerEmail.ListingsEmails.request_approval(requested_by)
    |> VolunteerEmail.Mailer.deliver_now!()
  end

  # TODO: This needs the same transactionality treatment as `refresh/1`
  def approve!(listing, approved_by) do
    {:ok, approved_listing} =
      Repo.transaction(fn ->
        approved_listing =
          listing
          |> Change.approve(approved_by)
          |> Repo.update!()

        _email =
          approved_listing
          |> VolunteerEmail.ListingsEmails.on_approval(approved_by)
          |> VolunteerEmail.Mailer.deliver_now!()

        approved_listing
      end)

    approved_listing
  end

  # TODO: This needs the same transactionality treatment as `refresh/1`
  def unapprove!(listing, unapproved_by) do
    {:ok, unapproved_listing} =
      Repo.transaction(fn ->
        unapproved_listing =
          listing
          |> Change.unapprove()
          |> Repo.update!()

        _email =
          unapproved_listing
          |> VolunteerEmail.ListingsEmails.on_unapproval(unapproved_by)
          |> VolunteerEmail.Mailer.deliver_now!()

        unapproved_listing
      end)

    unapproved_listing
  end

  # TODO: This needs the same transactionality treatment as `refresh/1`
  def expire!(listing) do
    listing
    |> Change.expire()
    |> Repo.update!()
  end

  # TODO: This needs the same transactionality treatment as `refresh/1`
  def expiry_reminder_sent!(listing) do
    listing
    |> Change.expiry_reminder_sent()
    |> Repo.update!()
  end

  # NOTE: Only listings that are approved and not expired can be refreshed.
  # This constraint is expressed in the update query and preserved in the
  # database, to prevent against double-writes. We could also use the
  # SERIALIZABLE transaction isolation level to guard against this, but we'd
  # need to fetch the listing again inside the transaction (and not use the
  # listing object that's been passed to us).
  def refresh(listing) do
    case Change.refresh(listing) do
      %{valid?: true, changes: changes} ->
        Repo.transaction(fn ->
          from(l in Volunteer.Listings.base_query())
          |> Filters.unexpired()
          |> Filters.approved()
          |> update(set: ^Enum.into(changes, []))
          |> Repo.update_all([])
          |> case do
            {1, [listing]} ->
              listing

            result ->
              IO.inspect(result)
              Repo.rollback(:broken_invariant)
          end
        end)

      %{valid?: false} = changeset ->
        {:error, changeset}
    end
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
