defprotocol VolunteerWeb.Presenters.Title do
  @fallback_to_any true

  @doc "human readable title in text form"
  def plain(struct, opts \\ %{})

  @doc "human readable title with html tags"
  def bolded(struct, opts \\ %{})
end

defimpl VolunteerWeb.Presenters.Title, for: Any do
  import Phoenix.HTML

  def plain(struct, _opts \\ %{}) do
    struct.title
  end

  def bolded(struct, opts \\ %{}) do
    ~E"<%= plain(struct, opts) %>"
  end
end

defimpl VolunteerWeb.Presenters.Title, for: Volunteer.Infrastructure.Region do
  import Phoenix.HTML

  def plain(region, opts \\ %{})

  def plain(region, opts) do
    "#{region.title}#{suffix(region, opts)}"
  end

  def bolded(region, opts \\ %{})

  def bolded(region, %{with_parent: true} = opts) do
    ~E"<strong><%= region.title %></strong><%= suffix(region, opts) %>"
  end

  def bolded(region, _opts) do
    ~E"<%= region.title %>"
  end

  def suffix(region, %{with_parent: true}) do
    case region.parent_id do
      nil ->
        ""

      _id ->
        case region.parent do
          %{__struct__: Ecto.Association.NotLoaded} ->
            raise "Parent association not loaded, cannot present bolded"

          parent ->
            ", #{VolunteerWeb.Presenters.Title.plain(parent, %{with_parent: false})}"
        end
    end
  end

  def suffix(_region, _opts) do
    ""
  end
end

defimpl VolunteerWeb.Presenters.Title, for: Volunteer.Infrastructure.Group do
  import Phoenix.HTML

  def plain(group, opts \\ %{})

  def plain(group, _opts) do
    group.title
  end

  def bolded(group, opts \\ %{})

  def bolded(group, _opts) do
    case group.region do
      %{__struct__: Ecto.Association.NotLoaded} ->
        raise "Group association not loaded, cannot present bolded"

      region ->
        cond do
          String.ends_with?(group.title, "for #{region.title}") ->
            ~E"<strong><%= group.title %></strong>"

          String.ends_with?(group.title, region.title) ->
            ~E"<strong><%= group.title |> String.trim_trailing(region.title) |> String.trim %></strong> <%= region.title %>"

          true ->
            ~E"<strong><%= group.title %></strong>"
        end
    end
  end
end

defimpl VolunteerWeb.Presenters.Title, for: Volunteer.Listings.Listing do
  import Phoenix.HTML

  def plain(listing, _opts \\ %{}) do
    "#{listing.position_title}#{suffix(listing)}"
  end

  def bolded(listing, _opts \\ %{}) do
    ~E"<strong><%= listing.position_title %></strong><%= suffix(listing) %>"
  end

  def suffix(listing) do
    case listing.program_title do
      "" -> ""
      _ -> " for #{listing.program_title}"
    end
  end
end
