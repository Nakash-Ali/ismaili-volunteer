defmodule Volunteer.Listings.MarketingRequest.ImageChannel do
  use Ecto.Schema
  import Ecto.Changeset
  alias Volunteer.Listings.MarketingRequest.ChannelAttrs

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
