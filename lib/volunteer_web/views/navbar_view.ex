defmodule VolunteerWeb.NavbarView do
  use VolunteerWeb, :view
  alias VolunteerWeb.Features

  def render_navbar(assigns) do
    Features.generate_and_identify(:navbar, assigns)
    |> Enum.map(&render_navbar_item(&1, assigns))
  end

  def render_navbar_item(%Features.Item{} = item, assigns) do
    render("item.html", Map.merge(assigns, %{item: item}))
  end
end
