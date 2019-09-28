defmodule Volunteer.Listings.MarketingRequest do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.Listings.MarketingRequest.TextChannel
  alias Volunteer.Listings.MarketingRequest.ImageChannel
  alias Volunteer.Listings.MarketingRequest.TextImageChannel

  schema "marketing_requests" do
    field :start_date, :date, default: Date.utc_today()
    field :target_jamatkhanas, {:array, :string}
    embeds_many :text_channels, TextChannel
    embeds_many :image_channels, ImageChannel
    embeds_many :text_image_channels, TextImageChannel
  end

  @attributes_cast_always [
    :start_date,
    :target_jamatkhanas
  ]

  @attributes_required_always @attributes_cast_always

  @mapping %{
    "text" => TextChannel,
    "image" => ImageChannel,
    "text_image" => TextImageChannel
  }

  def new(channels, assigns) do
    channels
    |> initial(assigns)
    |> change()
  end

  def create(channels, assigns, attrs) do
    channels
    |> initial(assigns)
    |> cast(attrs, @attributes_cast_always)
    |> Volunteer.StringSanitizer.sanitize_changes([:target_jamatkhanas], %{type: :text})
    |> validate_required(@attributes_required_always)
    |> cast_embed(:text_channels)
    |> cast_embed(:image_channels)
    |> cast_embed(:text_image_channels)
    |> validate_atleast_one_in_any_channel([:text_channels, :image_channels, :text_image_channels])
  end

  defp initial(channels, assigns) do
    %__MODULE__{
      text_channels: initial_channels_for_type(TextChannel, channels, assigns),
      image_channels: initial_channels_for_type(ImageChannel, channels, assigns),
      text_image_channels: initial_channels_for_type(TextImageChannel, channels, assigns)
    }
  end

  defp initial_channels_for_type(required_channel_module, channels, assigns) do
    channels
    |> Enum.map(fn {title, str_type} -> {Map.fetch!(@mapping, str_type), title} end)
    |> Enum.filter(fn {channel_module, _title} -> channel_module == required_channel_module end)
    |> Enum.map(fn {channel_module, title} -> channel_module.initial(title, assigns) end)
  end

  defp validate_atleast_one_in_any_channel(changeset, channels) do
    channels
    |> Enum.flat_map(&get_field(changeset, &1, []))
    |> Enum.filter(&Map.get(&1, :enabled, false))
    |> Enum.any?()
    |> case do
      true ->
        changeset

      false ->
        add_error(changeset, :_minimum_channels, "At least one channel should be selected")
    end
  end

  def filter_disabled_channels(marketing_request) do
    marketing_request
    |> filter_disabled_channel_type(:text_channels)
    |> filter_disabled_channel_type(:image_channels)
    |> filter_disabled_channel_type(:text_image_channels)
  end

  defp filter_disabled_channel_type(marketing_request, channel_type) do
    Map.update!(marketing_request, channel_type, fn channels ->
      Enum.filter(channels, &Map.fetch!(&1, :enabled))
    end)
  end
end
