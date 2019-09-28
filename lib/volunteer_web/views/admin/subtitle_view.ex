defmodule VolunteerWeb.Admin.SubtitleView do
	use VolunteerWeb, :view

  def with_nav(nav_items, active_nav, assigns) do
    render(
      "with_nav.html",
      [nav_items: mark_nav_items_active(nav_items, active_nav)] ++ assigns
    )
  end

  def mark_nav_items_active(nav_items, active_nav) do
    Enum.map(nav_items, fn {title, path} ->
    	case String.downcase(title) do
    	  ^active_nav ->
    		{title, path, "active"}

    	  _ ->
    		{title, path, ""}
    	end
  	end)
  end
end
