defmodule Volunteer.MarketingRequests.Change do
  import Ecto.Changeset
  alias Volunteer.MarketingRequests.MarketingRequest
  alias Volunteer.MarketingRequests.TextChannel
  alias Volunteer.MarketingRequests.ImageChannel
  alias Volunteer.MarketingRequests.TextImageChannel

  @attributes_cast_always [
    :start_date,
    :targets,
    :targets_all,
  ]

  @attributes_required_always [
    :start_date
  ]

  @type_mapping %{
    "text" => :text_channels,
    "image" => :image_channels,
    "text_image" => :text_image_channels,
  }

  @module_mapping %{
    :text_channels => TextChannel,
    :image_channels => ImageChannel,
    :text_image_channels => TextImageChannel
  }

  def new(%{channels_allowed: channels_allowed}, assigns) do
    channels_allowed
    |> initial(assigns)
    |> change()
  end

  def create(%{channels_allowed: channels_allowed, targets_allowed: targets_allowed} = config, assigns, attrs) do
    channels_allowed
    |> initial(assigns)
    |> cast(attrs, @attributes_cast_always)
    |> Volunteer.StringSanitizer.sanitize_changes([:targets], %{type: :text})
    |> validate_required(@attributes_required_always)
    |> validate_targets(targets_allowed)
    |> cast_embed(:text_channels)
    |> cast_embed(:image_channels)
    |> cast_embed(:text_image_channels)
    |> validate_minimum_channels_selected(config.channels_allowed)
  end

  def group_channels_by_type(channels_allowed) do
    Enum.group_by(
      channels_allowed,
      fn {_title, str_type} ->
        Map.fetch!(@type_mapping, str_type)
      end,
      fn {title, _str_type} ->
        title
      end
    )
  end

  def filter_enabled_and_allowed_channels(marketing_request, channels_allowed) do
    @module_mapping
    |> Map.keys()
    |> Enum.reduce(marketing_request, fn type, marketing_request ->
      Map.update!(marketing_request, type, fn channels ->
        allowed_title_list = Map.get(channels_allowed, type, [])

        Enum.filter(channels, fn channel ->
          case channel do
            %{enabled: false} ->
              false

            %{enabled: true, title: title} ->
              Enum.member?(allowed_title_list, title)
          end
        end)
      end)
    end)
  end

  defp initial(channels_allowed, assigns) do
    initial_channels =
      channels_allowed
      |> Enum.map(fn {type, title_list} ->
        module = Map.fetch!(@module_mapping, type)
        channels = Enum.map(title_list, &module.initial(&1, assigns))
        {type, channels}
      end)
      |> Enum.into(%{})

    struct(MarketingRequest, initial_channels)
  end

  defp validate_targets(changeset, targets_allowed) do
    case fetch_field(changeset, :targets_all) do
      {_, true} ->
        changeset

      {_, false} ->
        changeset
        |> validate_required(:targets)
        |> validate_subset(:targets, targets_allowed)
        |> validate_length(:targets, min: 1)
    end
  end

  # NOTE: We can't effectively handle this for the national case when regions
  # have differing channels available. For example, let's say region_a has allowed
  # channels 1 & 2, and region_b has allowed channels 2 & 3. The national form
  # will show channels 1, 2, & 3. Let's say the user selects both regions, but
  # only enables channel 3. This function will assume the changeset is valid,
  # when actually it's only valid for region_b. Once the request is delegated to
  # region_a, the changeset will actually be invalid. Maybe we need to run the
  # whole changeset from the perspective of each region in a delegated request!
  # Therefore, a national delegated request will only be correct when it is correct
  # for all the regions it will be delegated to!
  defp validate_minimum_channels_selected(changeset, channels_allowed) do
    channels_allowed
    |> Enum.flat_map(fn {type, _titles} -> get_field(changeset, type) end)
    |> Enum.filter(&Map.fetch!(&1, :enabled))
    |> Enum.any?
    |> case do
      true ->
        changeset

      false ->
        add_error(changeset, :_minimum_channels, "At least one channel should be selected")
    end
  end
end
