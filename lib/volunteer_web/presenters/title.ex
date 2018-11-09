defprotocol VolunteerWeb.Presenters.Title do
  @fallback_to_any true

  @doc "human readable title in text form"
  def text(struct, opts \\ %{})

  @doc "human readable title with html tags"
  def html(struct, opts \\ %{})
end

defimpl VolunteerWeb.Presenters.Title, for: Any do
  import Phoenix.HTML

  def text(struct, _opts \\ %{}) do
    struct.title
  end

  def html(struct, opts \\ %{}) do
    ~E"<%= text(struct, opts) %>"
  end
end

defimpl VolunteerWeb.Presenters.Title, for: Volunteer.Infrastructure.Region do
  import Phoenix.HTML

  def text(region, opts \\ %{})

  def text(region, %{with_parent: true}) do
    if region.parent_id != nil do
      "#{region.title}, #{region.parent.title}"
    else
      region.title
    end
  end

  def text(region, _opts) do
    region.title
  end

  def html(region, opts \\ %{}) do
    ~E"<%= text(region, opts) %>"
  end
end

defimpl VolunteerWeb.Presenters.Title, for: Volunteer.Listings.Listing do
  import Phoenix.HTML

  def text(listing, _opts \\ %{}) do
    "#{listing.position_title}#{suffix(listing)}"
  end

  def html(listing, _opts \\ %{}) do
    ~E"<strong><%= listing.position_title %></strong><%= suffix(listing) %>"
  end

  def suffix(listing) do
    case listing.program_title do
      "" -> ""
      _ -> " for #{listing.program_title}"
    end
  end
end
