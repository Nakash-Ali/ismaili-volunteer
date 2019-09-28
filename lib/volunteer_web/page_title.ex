defmodule VolunteerWeb.PageTitle do
  @suffix Application.fetch_env!(:volunteer, :global_title)
  @joiner " - "

  def render(assigns) do
    assigns |> title |> join
  end

  defp join(title_string) when is_binary(title_string) do
    join([title_string])
  end

  defp join(list_of_title_strings) when is_list(list_of_title_strings) do
    [@suffix | list_of_title_strings]
    |> Enum.reverse()
    |> Enum.join(@joiner)
  end

  # TODO: Fix this to work correctly
  # def title(%{view_module: VolunteerWeb.ListingView, listing: listing}) do
  #   [
  #     "Listings",
  #     VolunteerWeb.Presenters.Title.plain(listing)
  #   ]
  # end

  def title(_) do
    []
  end
end
