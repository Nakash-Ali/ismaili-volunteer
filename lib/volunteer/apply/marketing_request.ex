defmodule Volunteer.Apply.MarketingRequest do
  import Ecto.Changeset
  
  defmodule ChannelAttrs do  
    @all [
      :enabled,
      :title,
      :text,
      :image_url,
    ] |> MapSet.new
    
    def cast_always(module) do
      module.__schema__(:fields)
      |> MapSet.new
      |> MapSet.intersection(@all)
      |> MapSet.to_list
    end
    
    def required_always(module) do
      cast_always(module)
    end
  end
  
  defmodule TextChannel do
    use Ecto.Schema
    alias VolunteerWeb.Presenters.Title
    
    embedded_schema do
      field :enabled, :boolean, default: false
      field :title, :string
      field :text, :string
    end
    
    def changeset(channel, attrs) do
      channel
      |> cast(attrs, ChannelAttrs.cast_always(__MODULE__))
      |> validate_required(ChannelAttrs.required_always(__MODULE__))
      |> validate_length(:text, max: 400)
    end
    
    def initial(title, assigns) do
      %{
        "title" => title,
        "text" => apply_template(title, assigns)
      }
    end
    
    defp apply_template("JK announcement", %{listing: listing}) do
      "#{listing.group.title} is looking for volunteers for #{listing.program_title}. To learn more, go to https://iicanada.org/serveontario"
    end
    
    defp apply_template(_title, %{listing: listing}) do
      "#{listing.group.title} is looking for a #{Title.text(listing)}. For more information on this and other volunteer opportunities, go to https://iicanada.org/serveontario"
    end
  end
  
  defmodule ImageChannel do
    use Ecto.Schema
    
    embedded_schema do
      field :enabled, :boolean, default: false
      field :title, :string
      field :image_url, :string
    end
    
    def changeset(channel, attrs) do
      channel
      |> cast(attrs, ChannelAttrs.cast_always(__MODULE__))
      |> validate_required(ChannelAttrs.required_always(__MODULE__))
    end
    
    def initial(title, _assigns) do
      %{
        "title" => title
      }
    end
  end
  
  defmodule TextImageChannel do
    use Ecto.Schema
    
    embedded_schema do
      field :enabled, :boolean, default: false
      field :title, :string
      field :text, :string
      field :image_url, :string
    end
    
    def changeset(channel, attrs) do
      channel
      |> cast(attrs, ChannelAttrs.cast_always(__MODULE__))
      |> validate_required(ChannelAttrs.required_always(__MODULE__))
    end
    
    def initial(title, _assigns) do
      %{
        "title" => title
      }
    end
  end
  
  use Ecto.Schema
  
  schema "marketing_requests" do
    field :start_date, :date, default: Timex.now() |> Timex.to_date()
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
    "Al-Akhbar" => TextChannel,
    "IICanada App & Website" => TextChannel,
    "JK announcement" => TextChannel,
    "JK LCD screen" => ImageChannel,
    "Facebook" => TextImageChannel,
    "Instagram" => TextImageChannel,
  }
  
  def default_channels() do
    [
      "Al-Akhbar",
      "IICanada App & Website",
      "JK announcement",
    ]
  end
  
  def new(channels, assigns) do
    changeset(channels, assigns, %{})
  end
  
  def create(channels, assigns, attrs) do
    changeset(channels, assigns, attrs)
    |> validate_atleast_one_in_any_channel([:text_channels, :image_channels, :text_image_channels])
    |> case do
      %{valid?: true} = changeset ->
        changeset
        |> filter_disabled_channel(:text_channels)
        |> filter_disabled_channel(:image_channels)
        |> filter_disabled_channel(:text_image_channels)
      changeset -> changeset  
    end
  end

  def changeset(channels, assigns, attrs) do
    merged_attrs =
      channels
      |> initial(assigns)
      |> merge_initial_with_attrs(attrs)
    %__MODULE__{}
    |> cast(merged_attrs, @attributes_cast_always)
    |> validate_required(@attributes_required_always)
    |> cast_embed(:text_channels)
    |> cast_embed(:image_channels)
    |> cast_embed(:text_image_channels)
  end
  
  def initial(channels, assigns) do
    %{
      "text_channels" => initial_channels_for_type(TextChannel, channels, assigns),
      "image_channels" => initial_channels_for_type(ImageChannel, channels, assigns),
      "text_image_channels" => initial_channels_for_type(TextImageChannel, channels, assigns),
    }
  end
  
  def initial_channels_for_type(required_channel_type, channels, assigns) do
    channels
    |> Enum.map(fn title -> {Map.fetch!(@mapping, title), title} end)
    |> Enum.filter(fn {channel_type, _title} -> channel_type == required_channel_type end)
    |> Enum.map(fn {channel_type, title} -> channel_type.initial(title, assigns) end)
    |> Volunteer.Utils.list_to_map
  end
  
  def merge_initial_with_attrs(initial, attrs) do
    Map.merge(initial, attrs)
    |> Map.put("text_channels", merge_channel("text_channels", initial, attrs))
    |> Map.put("image_channels", merge_channel("image_channels", initial, attrs))
    |> Map.put("text_image_channels", merge_channel("text_image_channels", initial, attrs))
  end
  
  def merge_channel(key, initial, attrs) do
    initial_channels = Map.get(initial, key, %{})
    attrs_channels = Map.get(attrs, key, %{})
    Map.merge(
      initial_channels,
      attrs_channels,
      fn _key, v1, v2 -> Map.merge(v1, v2) end
    )
  end
  
  def validate_atleast_one_in_any_channel(changeset, channels) do
    channels
    |> Enum.flat_map(&get_field(changeset, &1, []))
    |> Enum.filter(&Map.get(&1, :enabled, false))
    |> Enum.any?
    |> case do
      true ->
        changeset
      false ->
        add_error(changeset, :_minimum_channels, "At least one channel should be selected")
    end
  end
  
  def filter_disabled_channel(changeset, channel) do
    filtered = 
      changeset
      |> get_field(channel)
      |> Enum.filter(&Map.get(&1, :enabled, false))
    put_change(changeset, channel, filtered)
  end
end
