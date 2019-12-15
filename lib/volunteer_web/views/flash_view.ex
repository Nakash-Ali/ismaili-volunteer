defmodule VolunteerWeb.FlashView do
  use VolunteerWeb, :view

  @content_templates %{
    paragraph: "paragraph.html",
    structured: "structured.html",
  }

  def render_all(%Plug.Conn{} = conn) do
    Enum.map(
      VolunteerWeb.FlashHelpers.configs(),
      &render_one(conn, &1)
    )
  end

  def render_one(%Plug.Conn{} = conn, flash_config) do
    case get_flash(conn, flash_config.type) do
      {content_type, content} ->
        render(
          Map.fetch!(@content_templates, content_type),
          Map.merge(flash_config, %{do: content})
        )

      content when is_binary(content) ->
        raise """
        Raw strings are not supported as flash content. Please use one of the
        explicit functions in the `VolunteerWeb.FlashHelpers` module to render
        flashes correctly.
        """

      nil ->
        []
    end
  end
end
