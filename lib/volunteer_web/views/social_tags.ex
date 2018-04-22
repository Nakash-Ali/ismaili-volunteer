defmodule VolunteerWeb.SocialTags do
  
  # TODO: turn this into a protocl that each view can implement
  
  def render(assigns) do
    base_tags(assigns)
    |> Map.merge(page_tags(assigns))
    |> Enum.map(&render_tag/1)
  end
  
  defp render_tag({key, value}) do
    Phoenix.HTML.Tag.tag(:meta, property: key, content: value)
  end
  
  defp base_tags(_assigns) do
    social_config = Application.fetch_env!(:volunteer, :social)
    %{
      "fb:app_id" => Keyword.fetch!(social_config, :facebook_app_id),
      "og:url" => Keyword.fetch!(social_config, :url),
      "og:type" => Keyword.fetch!(social_config, :type),
      "og:title" => Keyword.fetch!(social_config, :title),
      "og:description" => Keyword.fetch!(social_config, :description),
      "og:image" => Keyword.fetch!(social_config, :image),
    }
  end
  
  defp page_tags(%{ view_module: view_module } = assigns) do
    case Kernel.function_exported?(view_module, :social_tags, 1) do
      true ->
        view_module.social_tags(assigns)
      false ->
        %{}
    end
  end
end
