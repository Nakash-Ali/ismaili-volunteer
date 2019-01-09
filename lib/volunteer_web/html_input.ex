defmodule VolunteerWeb.HTMLInput do
  @semtex_config Semtex.config()
                 |> Map.update!(
                   "allowed_tags",
                   &Enum.reject(&1, fn tag ->
                     if tag in ["h1", "h2", "h3", "h4", "h5", "h6"], do: true
                   end)
                 )

  def sanitize(raw_html) do
    raw_html
    |> collapse_terminating_linebreaks
    |> Semtex.sanitize!(@semtex_config)
    |> Semtex.serialize!(@semtex_config)
  end

  def collapse_terminating_linebreaks(html) do
    Regex.replace(~r/^\s*(?:<br\s*\/?\s*>)+|(?:<br\s*\/?\s*>)+\s*$/, html, "")
  end

  def deserialize_for_show(raw_html) do
    Phoenix.HTML.raw(raw_html)
  end

  def deserialize_for_edit(raw_html) do
    Phoenix.HTML.raw(raw_html)
  end
end
