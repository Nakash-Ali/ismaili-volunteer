defmodule Volunteer.Listings.MarketingRequest.TextChannel do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :enabled, :boolean, default: false
    field :title, :string
    field :text, :string
  end

  def changeset(channel, attrs) do
    channel
    |> cast(attrs, [:enabled, :title, :text])
    |> Volunteer.StringSanitizer.sanitize_changes([:title, :text], %{type: :text})
    |> validate_required([:enabled, :title, :text])
    |> validate_length(:text, max: 400)
  end

  def initial(title, assigns) do
    %{
      "title" => title,
      "text" => apply_template(title, assigns)
    }
  end

  defp apply_template(_title, %{listing: listing, ots_website: ots_website}) do
    for_text =
      if listing.program_title != "" do
        "volunteers for #{listing.program_title}"
      else
        "a #{listing.position_title}"
      end

    "#{listing.group.title} is looking for #{for_text}. For more information on this and other volunteer opportunities, go to #{ots_website}"
  end
end
