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
end
