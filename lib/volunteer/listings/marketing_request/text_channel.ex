defmodule Volunteer.Listings.MarketingRequest.TextChannel do
  use Ecto.Schema
  import Ecto.Changeset
  alias Volunteer.Listings.MarketingRequest.ChannelAttrs

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

  defp apply_template(_title, %{listing: listing}) do
    {:ok, website} = Volunteer.Infrastructure.get_region_config(listing.region_id, :website)

    for_text =
      if listing.program_title != "" do
        "volunteers for #{listing.program_title}"
      else
        "a #{listing.position_title}"
      end

    "#{listing.group.title} is looking for #{for_text}. For more information on this and other volunteer opportunities, go to #{website}"
  end
end
