defprotocol VolunteerWeb.Presenters.Title do
  @fallback_to_any true

  @doc "human readable title in text form"
  def text(struct)

  @doc "human readable title with html tags"
  def html(struct)
end

defimpl VolunteerWeb.Presenters.Title, for: Any do
  import Phoenix.HTML

  def text(struct) do
    struct.title
  end

  def html(struct) do
    ~E"<%= text(struct) %>"
  end
end

defimpl VolunteerWeb.Presenters.Title, for: Volunteer.Apply.Listing do
  import Phoenix.HTML

  def text(listing) do
    "#{listing.position_title}#{suffix(listing)}"
  end

  def html(listing) do
    ~E"<strong><%= listing.position_title %></strong><%= suffix(listing) %>"
  end

  def suffix(listing) do
    case listing.program_title do
      "" -> ""
      _ -> " for #{listing.program_title}"
    end
  end
end
