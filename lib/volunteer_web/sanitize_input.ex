defmodule VolunteerWeb.SanitizeInput do
  def text_params(input_params, keys_to_sanitize) do
    params(input_params, keys_to_sanitize, &text/1)
  end
  
  def textarea_params(input_params, keys_to_sanitize) do
    params(input_params, keys_to_sanitize, &textarea/1)
  end
  
  def text(input) do
    input
    |> Floki.text
    |> collapse_whitespace
    |> String.trim
  end
  
  def textarea(input) do
    input
    |> HtmlSanitizeEx.basic_html
    |> collapse_terminating_linebreaks
    |> Floki.parse
    |> Floki.filter_out("h1")
    |> Floki.filter_out("h2")
    |> Floki.filter_out("h3")
    |> Floki.filter_out("h4")
    |> Floki.filter_out("h5")
    |> Floki.filter_out("h6")
    |> Floki.raw_html
  end
  
  defp params(input_params, [], _sanitizer) do
    input_params
  end
  
  defp params(input_params, keys_to_sanitize, sanitizer) when is_list(keys_to_sanitize) do
    input_params
    |> Enum.map(fn {key, value} ->
      case Enum.member?(keys_to_sanitize, key) do
        true ->
          {key, sanitizer.(value)}
        false ->
          {key, value}
      end
    end)
    |> Enum.into(%{})
  end
  
  def collapse_whitespace(text) do
    Regex.replace(~r/\s+/, text, " ")
  end
  
  def collapse_terminating_linebreaks(html) do
    Regex.replace(~r/^\s*(?:<br\s*\/?\s*>)+|(?:<br\s*\/?\s*>)+\s*$/, html, "")
  end
end
