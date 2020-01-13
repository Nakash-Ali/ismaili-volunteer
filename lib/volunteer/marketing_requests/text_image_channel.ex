defmodule Volunteer.MarketingRequests.TextImageChannel do
  use Volunteer, :schema
  import Ecto.Changeset
  alias Volunteer.MarketingRequests.Channel

  embedded_schema do
    field :enabled, :boolean, default: false
    field :title, :string
    field :text, :string
    field :image_url, :string
  end

  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:enabled, :title, :text, :image_url])
    |> Volunteer.StringSanitizer.sanitize_changes([:title, :text], %{type: :text})
    |> validate_required([:enabled, :title, :text, :image_url])
  end

  def initial(title, assigns) do
    %__MODULE__{
      id: Channel.id(title, assigns),
      title: title,
      text: "Oops",
      image_url: assigns.listing_social_image
    }
  end
end
