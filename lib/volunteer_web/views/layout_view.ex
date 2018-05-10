defmodule VolunteerWeb.LayoutView do
  use VolunteerWeb, :view
  alias VolunteerWeb.PageTitle
  alias VolunteerWeb.SocialTags
  alias VolunteerWeb.NavbarItems
  
  def render_or_fallback(prefix, assigns) do
    %{view_module: view_module, view_template: view_template} = assigns
    render_existing(view_module, prefix <> "." <> view_template, assigns) ||
  		render(prefix <> ".html", assigns)
  end
end
