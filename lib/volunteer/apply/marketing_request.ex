defmodule Volunteer.Apply.MarketingRequest do
  import Ecto.Changeset
  
  defmodule TextChannel do
    use Ecto.Schema
    alias VolunteerWeb.Presenters.Title
    
    embedded_schema do
      field :enabled, :boolean, default: true
      field :type, :string
      field :text, :string
    end
    
    @attributes_cast_always [
      :enabled,
      :type,
      :text
    ]
    
    @attributes_required_always @attributes_cast_always
    
    @types [
      "Al-Akhbar",
      "IICanada App & Website",
      "JK announcement",
    ]
    
    def types do
      @types
    end
    
    def changeset(channel, attrs) do
      channel
      |> cast(attrs, @attributes_cast_always)
      |> validate_required(@attributes_required_always)
      |> validate_inclusion(:type, @types)
      |> validate_length(:text, max: 400)
    end
    
    def initial_data(type, assigns) do
      %{
        type: type,
        text: apply_template(type, assigns)
      }
    end
    
    def get_template(type) do
      @types
      |> Map.fetch!(type)
      |> Map.fetch!(:template)
    end
    
    def apply_template("JK announcement", %{listing: listing}) do
      "#{listing.group.title} is looking for volunteers for #{listing.program_title}. To learn more, go to https://iicanada.org/serveontario"
    end
    
    def apply_template(_type, %{listing: listing}) do
      "#{listing.group.title} is looking for a #{Title.text(listing)}. For more information on this and other volunteer opportunities, go to https://iicanada.org/serveontario"
    end
  end
  
  defmodule ImageChannel do
    @types [
      "JK LCD screen"
    ]
  end
  
  defmodule TextImageChannel do
    @types [
      "Facebook",
      "Instagram",
    ]
  end
  
  use Ecto.Schema
  
  schema "marketing_requests" do
    field :start_date, :date
    field :start_asap, :boolean, default: true
    field :target_jamatkhanas, {:array, :string}
    embeds_many :text_channels, TextChannel
    # embeds_many :image_channels, ImageChannel
    # embeds_many :text_image_channels, TextImageChannel
  end
  
  @attributes_cast_always [
    :start_date,
    :start_asap,
    :target_jamatkhanas
  ]
  
  @attributes_required_always @attributes_cast_always
  
  def new(params, text_channel_types, assigns) do
    text_channels =
      text_channel_types
      |> Enum.map(&TextChannel.initial_data(&1, assigns))
    params
    |> Map.merge(%{text_channels: text_channels})
    |> create
  end

  def create(params) do
    %__MODULE__{}
    |> cast(params, @attributes_cast_always)
    |> cast_embed(:text_channels)
    # |> cast_embed(:image_channels)
    # |> cast_embed(:text_image_channels)
    |> validate_required(@attributes_required_always)
  end
end
