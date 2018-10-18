defmodule Volunteer.Listings.MarketingRequest.TextChannel do
  use Ecto.Schema
  import Ecto.Changeset
  alias Volunteer.Listings.MarketingRequest.ChannelAttrs
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
