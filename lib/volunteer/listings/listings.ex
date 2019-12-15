defmodule Volunteer.Listings do
  import Ecto.Query

  alias Volunteer.Repo
  alias Volunteer.Roles
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Listings.Listing
  alias Volunteer.Listings.TKNListing
  alias Volunteer.Listings.MarketingRequest

  def new_listing do
    Listing.new()
  end

  def create_listing(attrs, created_by) do
    Repo.transaction(fn ->
      attrs
      |> Listing.create(created_by)
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

  def edit_listing(listing, attrs \\ %{}) do
    Listing.edit(listing, attrs)
  end

  def update_listing(listing, attrs \\ %{}) do
    listing
    |> edit_listing(attrs)
    |> Repo.update()
  end

  def delete_listing(listing) do
    Repo.delete(listing)
  end

  def listing_preloadables() do
    [:created_by, :approved_by, :region, :group, :organized_by]
  end

  def request_approval!(listing, requested_by) do
    listing
    |> VolunteerEmail.ListingsEmails.request_approval(requested_by)
    |> VolunteerEmail.Mailer.deliver_now!()
  end

  def approve_listing_if_not_expired!(listing, approved_by) do
    {:ok, approved_listing} =
      Repo.transaction(fn ->
        approved_listing =
          listing
          |> Listing.approve_if_not_expired(approved_by)
          |> Repo.update!()

        _email =
          approved_listing
          |> VolunteerEmail.ListingsEmails.on_approval(approved_by)
          |> VolunteerEmail.Mailer.deliver_now!()

        approved_listing
      end)

    approved_listing
  end

  def unapprove_listing_if_not_expired!(listing, unapproved_by) do
    {:ok, unapproved_listing} =
      Repo.transaction(fn ->
        unapproved_listing =
          listing
          |> Listing.unapprove_if_not_expired()
          |> Repo.update!()

        _email =
          unapproved_listing
          |> VolunteerEmail.ListingsEmails.on_unapproval(unapproved_by)
          |> VolunteerEmail.Mailer.deliver_now!()

        unapproved_listing
      end)

    unapproved_listing
  end

  def expire_listing!(listing) do
    listing
    |> Listing.expire()
    |> Repo.update!()
  end

  def expiry_reminder_sent!(listing) do
    listing
    |> Listing.expiry_reminder_sent
    |> Repo.update!()
  end

  def refresh_and_maybe_unapprove_listing(listing) do
    listing
    |> Listing.refresh_and_maybe_unapprove()
    |> Repo.update()
  end

  def base_listing_query() do
    from(l in Listing, select_merge: %{
      start_date_toggle: is_nil(l.start_date),
      end_date_toggle: is_nil(l.end_date),
    })
  end

  def get_one_admin_listing!(id) do
    from(l in base_listing_query(),
      where: l.id == ^id)
    |> Repo.one!
  end

  def get_all_admin_listings(opts \\ []) do
    from(l in base_listing_query())
    |> query_listings_with_admin_state_filters(Keyword.get(opts, :filters, %{}))
    |> order_by(desc: :expiry_date)
    |> Repo.all()
  end

  def get_all_public_listings(opts \\ []) do
    from(l in base_listing_query())
    |> query_approved_listing()
    |> query_unexpired_listing()
    |> query_listings_with_region_filters(Keyword.get(opts, :filters, %{}))
    |> query_listings_with_group_filters(Keyword.get(opts, :filters, %{}))
    |> order_by(desc: :expiry_date)
    |> Repo.all()
  end

  def get_one_public_listing!(id, opts \\ []) do
    query_one_public_listing(id, opts) |> Repo.one!()
  end

  def get_one_public_listing(id, opts \\ []) do
    query_one_public_listing(id, opts) |> Repo.one()
  end

  def get_one_preview_listing!(id) do
    from(l in base_listing_query(), where: l.id == ^id)
    |> query_unexpired_listing()
    |> Repo.one!()
  end

  def get_all_listings_for_expiry_reminder(expiry_date) do
    from(l in base_listing_query())
    |> query_unexpired_listing()
    |> query_listings_expiring_before(expiry_date)
    |> query_expiry_reminder_not_sent()
    |> Repo.all()
  end

  defp query_listings_with_admin_state_filters(query, filters) when filters == %{} do
    query
  end

  defp query_listings_with_admin_state_filters(query, %{approved: true, unapproved: true, expired: true}) do
    query
  end

  defp query_listings_with_admin_state_filters(query, %{approved: false, unapproved: false, expired: false}) do
    from(l in query, where: fragment("1 = 0"))
  end

  defp query_listings_with_admin_state_filters(query, %{approved: true, unapproved: false, expired: false}) do
    query_approved_listing(query)
    |> query_unexpired_listing()
  end

  defp query_listings_with_admin_state_filters(query, %{approved: true, unapproved: true, expired: false}) do
    query_unexpired_listing(query)
  end

  defp query_listings_with_admin_state_filters(query, %{approved: true, unapproved: false, expired: true}) do
    current_time = VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
    from(l in query,
      where: l.approved == true
          or l.expiry_date < ^current_time)
  end

  defp query_listings_with_admin_state_filters(query, %{approved: false, unapproved: true, expired: false}) do
    query_unapproved_listing(query)
    |> query_unexpired_listing()
  end

  defp query_listings_with_admin_state_filters(query, %{approved: false, unapproved: true, expired: true}) do
    current_time = VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
    from(l in query,
      where: l.approved == false
          or l.expiry_date < ^current_time)
  end

  defp query_listings_with_admin_state_filters(query, %{approved: false, unapproved: false, expired: true}) do
    query_expired_listing(query)
  end

  defp query_one_public_listing(id, allow_expired: allow_expired) do
    query =
      from(l in base_listing_query(), where: l.id == ^id)
      |> query_approved_listing()

    if allow_expired do
      query
    else
      query
      |> query_unexpired_listing()
    end
  end

  defp query_approved_listing(query) do
    from(l in query, where: l.approved == true)
  end

  defp query_unapproved_listing(query) do
    from(l in query, where: l.approved == false)
  end

  defp query_expired_listing(query) do
    current_time = VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
    from(l in query, where: l.expiry_date < ^current_time)
  end

  defp query_unexpired_listing(query) do
    current_time = VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
    from(l in query, where: l.expiry_date >= ^current_time)
  end

  def query_listings_expiring_before(query, expiry_date) do
    from(l in query, where: l.expiry_date <= ^expiry_date)
  end

  def query_expiry_reminder_not_sent(query) do
    from(l in query, where: l.expiry_reminder_sent == false)
  end

  defp query_listings_with_region_filters(query, %{region_id: region_id, region_in_path: true}) when is_integer(region_id) do
    from(l in query,
      join: r in Region,
      on: l.region_id == r.id,
      where: r.id == ^region_id or fragment("?::integer[] && ?", [^region_id], r.parent_path))
  end

  defp query_listings_with_region_filters(query, %{region_id: region_id}) when is_integer(region_id) do
    from(l in query, where: l.region_id == ^region_id)
  end

  defp query_listings_with_region_filters(query, _filters) do
    query
  end

  defp query_listings_with_group_filters(query, %{group_id: group_id}) when is_integer(group_id) do
    from(l in query, where: l.group_id == ^group_id)
  end

  defp query_listings_with_group_filters(query, _filters) do
    query
  end

  def new_tkn_listing() do
    TKNListing.changeset(%TKNListing{}, %{})
  end

  def create_tkn_listing(listing, attrs) do
    TKNListing.changeset(%TKNListing{}, attrs, listing)
    |> Repo.insert()
  end

  def edit_tkn_listing(tkn_listing) do
    TKNListing.changeset(tkn_listing, %{})
  end

  def update_tkn_listing(tkn_listing, attrs) do
    TKNListing.changeset(tkn_listing, attrs)
    |> Repo.update()
  end

  def get_one_tkn_listing!(id) do
    Repo.get!(TKNListing, id)
  end

  def get_one_tkn_listing(id) do
    Repo.get(TKNListing, id)
  end

  def delete_tkn_listing(tkn_listing) do
    Repo.delete(tkn_listing)
  end

  def get_one_tkn_listing_for_listing!(id) do
    query_tkn_listing_for_listing(id)
    |> Repo.one!()
  end

  def get_one_tkn_listing_for_listing(id) do
    query_tkn_listing_for_listing(id)
    |> Repo.one()
  end

  def validate_tkn_assignment_spec_generation(listing, _tkn_listing) do
    case listing do
      %{start_date: nil} ->
        {:error, "start_date required"}

      %{start_date: _start_date} ->
        :ok
    end
  end

  defp query_tkn_listing_for_listing(id) do
    from(l in TKNListing, where: l.listing_id == ^id)
  end

  def assigns_for_marketing_request!(listing) do
    {:ok, ots_website} = Volunteer.Infrastructure.get_region_config(listing.region_id, :ots_website)

    %{
      listing: listing,
      ots_website: ots_website
    }
  end

  def new_marketing_request(listing, assigns) do
    config = config_for_marketing_request!(listing.region_id)
    assigns =
      Map.merge(
        assigns_for_marketing_request!(listing),
        assigns
      )

    marketing_request =
      MarketingRequest.new(config, assigns)

    {:ok, config, marketing_request}
  end

  def create_marketing_request(listing, assigns, attrs) do
    config = config_for_marketing_request!(listing.region_id)
    assigns =
      Map.merge(
        assigns_for_marketing_request!(listing),
        assigns
      )

    MarketingRequest.create(config, assigns, attrs)
    |> Ecto.Changeset.apply_action(:insert)
    |> case do
      {:ok, marketing_request} ->
        {:ok, config, unroll_marketing_requests!(config, marketing_request)}

      {:error, changeset} ->
        {:error, config, changeset}
    end
  end

  def config_for_marketing_request!(region_id) do
    {:ok, hardcoded_config} = Volunteer.Infrastructure.get_region_config(region_id, [:marketing_request])

    case hardcoded_config.strategy do
      :direct ->
        {:ok, jamatkhanas} = Volunteer.Infrastructure.get_region_config(region_id, [:jamatkhanas])

        %{
          recipient_id: region_id,
          recipient_type: :region,
          strategy: hardcoded_config.strategy,
          targets_type: :jamatkhana,
          targets_allowed: jamatkhanas,
          channels_allowed: MarketingRequest.group_channels_by_type(hardcoded_config.channels),
        }

      :delegate_to_child_regions ->
        child_regions = Volunteer.Infrastructure.get_regions(filters: %{parent_id: region_id})

        targets_configs =
          child_regions
          |> Enum.map(fn child_region ->
            {child_region.title, config_for_marketing_request!(child_region.id)}
          end)
          |> Enum.into(%{})

        targets_allowed =
          targets_configs
          |> Map.keys

        channels_allowed =
          targets_configs
          |> Map.values
          |> Enum.map(&(&1.channels_allowed))
          |> Enum.reduce(&Map.merge(&1, &2, fn
            _k, v1, v2 when is_list(v1) and is_list(v2) ->
              Enum.uniq(v1 ++ v2)

            _k, _v1, v2 ->
              v2
            end)
          )

        %{
          recipient_id: region_id,
          recipient_type: :region,
          strategy: hardcoded_config.strategy,
          targets_type: :region,
          targets_configs: targets_configs,
          targets_allowed: targets_allowed,
          channels_allowed: channels_allowed,
        }

    end
  end

  def unroll_marketing_requests!(%{strategy: :direct} = config, marketing_request) do
    marketing_request =
      # NOTE: The reason we need to remove disabled channels as a second step is because
      # When constructing channels for the `:delegate_to_child_regions`, we aggregate
      # available channels from all child regions. Now we need to split them up and make
      # sure that only the channels allowed for that particular child region are included
      MarketingRequest.filter_enabled_and_allowed_channels(marketing_request, config.channels_allowed)

    [
      {config, marketing_request}
    ]
  end

  def unroll_marketing_requests!(%{targets_type: :region, strategy: :delegate_to_child_regions} = config, marketing_request) do
    clean_marketing_request =
      marketing_request
      |> Map.put(:targets_all, true)
      |> Map.put(:targets, [])

    marketing_request
    |> case do
      %{targets_all: true} ->
        Map.values(config.targets_configs)

      %{targets_all: false, targets: targets} ->
        Enum.map(targets, &(Map.fetch!(config.targets_configs, &1)))
    end
    |> Enum.flat_map(&unroll_marketing_requests!(&1, clean_marketing_request))
  end

  def send_marketing_request(listing, assigns, attrs) do
    case create_marketing_request(listing, assigns, attrs) do
      {:ok, config, unrolled_requests} ->
        # NOTE: This is simply an optimization. We shouldn't fetch a bunch of
        # related data unless we're absolutely sure that we will need and use
        # that data. Only once we've validated and unrolled the marketing
        # request can we be sure of this. Otherwise, we would make this call in
        # the controller, and bear the extra load for when a marketing request
        # fails validation.
        preloaded_listing =
          Repo.preload(listing, Volunteer.Listings.listing_preloadables())

        emails =
          unrolled_requests
          |> Enum.map(fn {config, marketing_request} ->
            VolunteerEmail.ListingsEmails.marketing_request(config, marketing_request, preloaded_listing)
          end)
          |> Enum.map(&VolunteerEmail.Mailer.deliver_now!/1)

        {:ok, config, emails}

      {:error, _config, _changeset} = result ->
        result
    end
  end
end
