defmodule Volunteer.MarketingRequests do
  alias Volunteer.MarketingRequests.Change

  def assigns!(listing) do
    {:ok, ots_website} = Volunteer.Infrastructure.get_region_config(listing.region_id, :ots_website)

    %{
      listing: listing,
      ots_website: ots_website
    }
  end

  def new(listing, assigns) do
    config = config!(listing.region_id)
    assigns =
      Map.merge(
        assigns!(listing),
        assigns
      )

    marketing_request =
      Change.new(config, assigns)

    {:ok, config, marketing_request}
  end

  def create(listing, assigns, attrs) do
    config = config!(listing.region_id)
    assigns =
      Map.merge(
        assigns!(listing),
        assigns
      )

    Change.create(config, assigns, attrs)
    |> Ecto.Changeset.apply_action(:insert)
    |> case do
      {:ok, marketing_request} ->
        {:ok, config, unroll_marketing_requests!(config, marketing_request)}

      {:error, changeset} ->
        {:error, config, changeset}
    end
  end

  def config!(region_id) do
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
          channels_allowed: Change.group_channels_by_type(hardcoded_config.channels),
        }

      :delegate_to_child_regions ->
        child_regions = Volunteer.Infrastructure.get_regions(filters: %{parent_id: region_id})

        targets_configs =
          child_regions
          |> Enum.map(fn child_region ->
            {child_region.title, config!(child_region.id)}
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
      Change.filter_enabled_and_allowed_channels(marketing_request, config.channels_allowed)

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

  def send(listing, assigns, attrs) do
    case create(listing, assigns, attrs) do
      {:ok, config, unrolled_requests} ->
        # NOTE: This is simply an optimization. We shouldn't fetch a bunch of
        # related data unless we're absolutely sure that we will need and use
        # that data. Only once we've validated and unrolled the marketing
        # request can we be sure of this. Otherwise, we would make this call in
        # the controller, and bear the extra load for when a marketing request
        # fails validation.
        preloaded_listing =
          Repo.preload(listing, Volunteer.Listings.preloadables())

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
