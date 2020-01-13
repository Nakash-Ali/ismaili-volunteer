defmodule Volunteer.MarketingRequests.ImageChannel do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.MarketingRequests.Channel

  embedded_schema do
    field :enabled, :boolean, default: false
    field :title, :string
    field :image_url, :string
  end

  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:enabled, :title, :image_url])
    |> Volunteer.StringSanitizer.sanitize_changes([:title], %{type: :text})
    |> validate_required([:enabled, :title, :image_url])
  end

  def initial(title, assigns) do
    %__MODULE__{
      id: Channel.id(title, assigns),
      title: title,
      image_url: assigns.listing_social_image
    }
  end
end
