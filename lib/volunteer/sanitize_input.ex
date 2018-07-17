defmodule Volunteer.SanitizeInput do
  def text_attrs(input_attrs, keys_to_sanitize) do
    attrs(input_attrs, keys_to_sanitize, &text/1)
  end
  
  def html_attrs(input_attrs, keys_to_sanitize) do
    attrs(input_attrs, keys_to_sanitize, &html/1)
  end
  
  def text(input) do
    input
    |> collapse_whitespace
    |> String.trim
  end
  
  def html(input) do
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
  
  defp attrs([], input_attrs,  _sanitizer) do
    input_attrs
  end
  
  defp attrs(input_attrs, keys_to_sanitize, sanitizer) when is_list(keys_to_sanitize) do
    input_attrs
    |> Enum.map(fn {key, value} ->
      case Enum.member?(keys_to_sanitize, key) do
        true ->
          {key, do_sanitization(value, sanitizer)}
        false ->
          {key, value}
      end
    end)
    |> Enum.into(%{})
  end
  
  defp do_sanitization(value, sanitizer) when is_binary(value) do
    sanitizer.(value)
  end
  
  defp do_sanitization(_value, _sanitizer) do
    nil
  end
  
  def collapse_whitespace(text) do
    Regex.replace(~r/\s+/, text, " ")
  end
  
  def collapse_terminating_linebreaks(html) do
    Regex.replace(~r/^\s*(?:<br\s*\/?\s*>)+|(?:<br\s*\/?\s*>)+\s*$/, html, "")
  end
end
