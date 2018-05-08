defmodule VolunteerWeb.PageTitle do
  
  @suffix Application.fetch_env!(:volunteer, :project_title)
  @joiner " - "
  
  def render(assigns) do
    assigns |> title |> join
  end
  
  defp join(title_string) when is_binary(title_string) do
    join([title_string])
  end
  
  defp join(list_of_title_strings) when is_list(list_of_title_strings) do
    [ @suffix | list_of_title_strings ]
    |> Enum.reverse
    |> Enum.join(@joiner)
  end
  
  def title(%{view_module: VolunteerWeb.ListingView, listing: listing}) do
    [
      "Listings",
      VolunteerWeb.Presenters.Title.text(listing),
    ]
  end
  
  def title(%{view_module: VolunteerWeb.Legacy.ApplyView, view_template: "error.html"}) do
    "Error"
  end
  
  def title(%{view_module: VolunteerWeb.Legacy.ApplyView, view_template: "thank_you.html"}) do
    "Thank you!"
  end
  
  def title(_) do
    []
  end
end

# defprotocol VolunteerWeb.PageTitle.View do
#   def text(view_module, assigns)
# end
# 
# defimpl VolunteerWeb.PageTitle.View, for: Any do
#   def text(_view_module, _assigns) do
#     []
#   end
# end
# 
# defimpl VolunteerWeb.PageTitle.View, for: VolunteerWeb.ListingView do
#   alias VolunteerWeb.Presenters.Title
# 
#   def text(_view_module, %{listing: listing}) do
# 
#   end
# end
# 
# defimpl VolunteerWeb.PageTitle.View, for: VolunteerWeb.Legacy.ApplyView do
#   def text(_view_module, %{view_template: "error.html"}) do
#     "Error"
#   end
# 
#   def text(_view_module, %{view_template: "thank_you.html"}) do
#     "Thank you!"
#   end
# end
