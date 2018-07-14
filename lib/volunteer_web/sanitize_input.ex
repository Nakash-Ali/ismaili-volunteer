defmodule VolunteerWeb.SanitizeInput do
  def scrubadub_params(conn, opts) do
    # required_key = Keyword.fetch!(opts, :required_key)
    conn
    # |> Phoenix.Controller.scrub_params(required_key)
    # |> remove_nil_params(required_key)
    |> sanitize_params(opts)
  end
  
  def remove_nil_params(%Plug.Conn{params: params} = conn, required_key) do
    to_clean = Map.fetch!(params, required_key)
    cleaned =
      to_clean
      |> Enum.filter(fn
        {_key, nil} -> false
        {_key, ""} -> false
        {_key, _value} -> true
      end)
      |> Enum.into(%{})
    %Plug.Conn{conn | params: Map.put(params, required_key, cleaned)}
  end
  
  def sanitize_params(%Plug.Conn{params: params} = conn, opts) do
    required_key = Keyword.fetch!(opts, :required_key)
    to_sanitize = Map.fetch!(params, required_key)
    sanitized = 
      to_sanitize
      |> Map.merge(
        opts
        |> Keyword.get(:sanitize_text_params, [])
        |> text_params(to_sanitize)
      )
      |> Map.merge(
        opts
        |> Keyword.get(:sanitize_textarea_params, [])
        |> textarea_params(to_sanitize)
      )
    %Plug.Conn{conn | params: Map.put(params, required_key, sanitized)}
  end
  
  def text_params(keys_to_sanitize, input_params) do
    params(keys_to_sanitize, input_params, &text/1)
  end
  
  def textarea_params(keys_to_sanitize, input_params) do
    params(keys_to_sanitize, input_params, &textarea/1)
  end
  
  def text(input) do
    input
    # |> Floki.text
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
  
  defp params([], input_params,  _sanitizer) do
    input_params
  end
  
  defp params(keys_to_sanitize, input_params, sanitizer) when is_list(keys_to_sanitize) do
    input_params
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
