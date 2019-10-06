defmodule VolunteerWeb.Admin.SubtitleView do
	use VolunteerWeb, :view
  alias VolunteerWeb.Features

  def with_features_nav(features_id, assigns, additional_assigns) do
    render(
      "with_nav.html",
      assigns
      |> Map.merge(additional_assigns)
      |> Map.merge(%{nav_items: Features.generate_and_identify(features_id, assigns)})
    )
  end
end
