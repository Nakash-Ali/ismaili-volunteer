defmodule Volunteer.MarketingRequests.MarketingRequest do
  use Volunteer, :schema
  alias Volunteer.MarketingRequests.TextChannel
  alias Volunteer.MarketingRequests.ImageChannel
  alias Volunteer.MarketingRequests.TextImageChannel

  schema "marketing_requests" do
    field :start_date, :date, default: Date.utc_today()
    field :targets_all, :boolean, default: false
    field :targets, {:array, :string}
    embeds_many :text_channels, TextChannel
    embeds_many :image_channels, ImageChannel
    embeds_many :text_image_channels, TextImageChannel
  end
end
