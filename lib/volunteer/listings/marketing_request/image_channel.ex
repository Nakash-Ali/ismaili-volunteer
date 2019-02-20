defmodule Volunteer.Listings.MarketingRequest.ImageChannel do
  use Ecto.Schema
  import Ecto.Changeset

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

  def initial(title, _assigns) do
    %{
      "title" => title
    }
  end
end
