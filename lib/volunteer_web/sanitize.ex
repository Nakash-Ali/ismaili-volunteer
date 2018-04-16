defmodule VolunteerWeb.Sanitize do
  def params(input_params, []) do
    input_params
  end
  
  def params(input_params, keys_to_sanitize) when is_list(keys_to_sanitize) do
    input_params
    |> Enum.map(fn {key, value} ->
      case Enum.member?(keys_to_sanitize, key) do
        true ->
          {key, html(value)}
        false ->
          {key, value}
      end
    end)
    |> Enum.into(%{})
  end
  
  def html(input) do
    HtmlSanitizeEx.basic_html(input)
  end
end
