defmodule VolunteerWeb.SocialTags do
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
      "og:image" => Keyword.fetch!(social_config, :image)
    }
  end

  def popup_js() do
    "window.open(this.href, '_blank', 'left=100,top=100,width=900,height=600,menubar=no,toolbar=no,resizable=yes,scrollbars=yes'); return false;"
  end

  def page_tags(%{view_module: VolunteerWeb.ListingView, view_template: "show.html"} = assigns) do
    %{conn: conn, listing: listing} = assigns
    {width, height} = VolunteerWeb.Presenters.Social.image_src_size(listing)

    %{
      "og:title" => VolunteerWeb.Presenters.Social.title(listing),
      "og:description" => VolunteerWeb.Presenters.Social.description(listing),
      "og:url" => VolunteerWeb.Presenters.Social.url(listing, conn),
      "og:type" => VolunteerWeb.Presenters.Social.type(listing),
      "og:image" => VolunteerWeb.Presenters.Social.image_abs_url(listing, conn),
      "og:image:width" => width,
      "og:image:height" => height
    }
  end

  def page_tags(_) do
    %{}
  end
end

# defprotocol VolunteerWeb.SocialTags.View do
#   def tags(view_module, assigns)
# end
# 
# defimpl VolunteerWeb.SocialTags.View, for: Any do
#   def tags(_view_module, _assigns) do
#     %{}
#   end
# end
# 
# defimpl VolunteerWeb.SocialTags.View, for: VolunteerWeb.ListingView do
#   alias VolunteerWeb.Presenters.Social
# 
#   def tags(_view_module, %{conn: conn, view_template: "show.html", listing: listing}) do
#     {width, height} = Social.image_src_size(listing)
#     %{
#       "og:title" => Social.title(listing),
#       "og:description" => Social.description(listing),
#       "og:url" => Social.url(listing, conn),
#       "og:type" => Social.type(listing),
#       "og:image" => Social.image_abs_url(listing, conn),
#       "og:image:width" => width,
#       "og:image:height" => height,
#     }
#   end
# end
