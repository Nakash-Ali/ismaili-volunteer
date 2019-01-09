defmodule Volunteer.Listings.MarketingRequest do
  use Ecto.Schema
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
    changeset(%__MODULE__{}, channels, assigns, %{})
  end

  def create(channels, assigns, attrs) do
    changeset(%__MODULE__{}, channels, assigns, attrs)
    |> validate_atleast_one_in_any_channel([:text_channels, :image_channels, :text_image_channels])
    |> case do
      %{valid?: true} = changeset ->
        changeset
        |> filter_disabled_channel(:text_channels)
        |> filter_disabled_channel(:image_channels)
        |> filter_disabled_channel(:text_image_channels)

      changeset ->
        changeset
    end
  end

  defp changeset(marketing_request, channels, assigns, attrs) do
    fixed_attrs =
      channels
      |> initial(assigns)
      |> merge_initial_with_attrs(attrs)
      |> sanitize

    marketing_request
    |> cast(fixed_attrs, @attributes_cast_always)
    |> validate_required(@attributes_required_always)
    |> cast_embed(:text_channels)
    |> cast_embed(:image_channels)
    |> cast_embed(:text_image_channels)
  end

  defp initial(channels, assigns) do
    %{
      "text_channels" => initial_channels_for_type(TextChannel, channels, assigns),
      "image_channels" => initial_channels_for_type(ImageChannel, channels, assigns),
      "text_image_channels" => initial_channels_for_type(TextImageChannel, channels, assigns)
    }
  end

  defp initial_channels_for_type(required_channel_module, channels, assigns) do
    channels
    |> Enum.map(fn {title, str_type} -> {Map.fetch!(@mapping, str_type), title} end)
    |> Enum.filter(fn {channel_module, _title} -> channel_module == required_channel_module end)
    |> Enum.map(fn {channel_module, title} -> channel_module.initial(title, assigns) end)
    |> VolunteerUtils.Map.list_to_map()
  end

  defp merge_initial_with_attrs(initial, attrs) do
    Map.merge(initial, attrs)
    |> Map.put(
      "text_channels",
      merge_initial_with_attrs_for_channel(initial["text_channels"], attrs["text_channels"])
    )
    |> Map.put(
      "image_channels",
      merge_initial_with_attrs_for_channel(initial["image_channels"], attrs["image_channels"])
    )
    |> Map.put(
      "text_image_channels",
      merge_initial_with_attrs_for_channel(
        initial["text_image_channels"],
        attrs["text_image_channels"]
      )
    )
  end

  defp merge_initial_with_attrs_for_channel(initial_channels, nil) do
    initial_channels
  end

  defp merge_initial_with_attrs_for_channel(initial_channels, attrs_channels) do
    Map.merge(
      initial_channels,
      attrs_channels,
      fn _key, v1, v2 -> Map.merge(v1, v2) end
    )
  end

  defp sanitize(attrs) do
    attrs
    |> Map.put("text_channels", sanitize_for_channel(attrs["text_channels"]))
    |> Map.put("image_channels", sanitize_for_channel(attrs["image_channels"]))
    |> Map.put("text_image_channels", sanitize_for_channel(attrs["text_image_channels"]))
  end

  defp sanitize_for_channel(attrs) do
    VolunteerUtils.Map.update_all_values(
      attrs,
      &Volunteer.SanitizeInput.text_attrs(&1, ["title", "text"])
    )
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

  defp filter_disabled_channel(changeset, channel) do
    filtered =
      changeset
      |> get_field(channel)
      |> Enum.filter(&Map.get(&1, :enabled, false))

    put_change(changeset, channel, filtered)
  end
end
