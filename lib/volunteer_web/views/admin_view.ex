defmodule VolunteerWeb.AdminView do
  use VolunteerWeb, :view

  def render_definition_list(definition_list, opts \\ []) do
    Enum.map(definition_list, fn {title, body} ->
      render("definition_container.html", [title_text: title, body_text: body] ++ opts)
    end)
  end
end
