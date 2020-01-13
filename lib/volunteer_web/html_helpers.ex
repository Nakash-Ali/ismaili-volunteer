defmodule VolunteerWeb.HTMLHelpers do
  use VolunteerWeb, :view

  defguard is_non_empty_binary(text) when is_binary(text) and text != ""

  def icon_with_text(icon_class, icon_text) do
    ~E"""
    <i class="<%= icon_class %> mr-1q" aria-hidden="true"></i> <%= icon_text %>
    """
  end

  def with_position(list) do
    list
    |> Enum.with_index
    |> with_position([])
  end

  def with_position([], accum) do
    Enum.reverse(accum)
  end

  def with_position([{last, last_index}], accum) do
    with_position(
      [],
      [{last, last_index, :last} | accum]
    )
  end

  def with_position([{head, head_index} | tail], accum) do
    with_position(
      tail,
      [{head, head_index, nil} | accum]
    )
  end

  def io_join(list, str \\ " ") do
    List.foldr(list, [], fn
      item, [] -> [item]
      item, acc -> [item, str] ++ acc
    end)
  end

  def external_link(text) when is_non_empty_binary(text) do
    external_link(text, text)
  end

  def external_link(_text) do
    nil
  end

  def external_link(text, protocol_or_location, opts \\ [])

  def external_link(text, protocol, opts) when is_non_empty_binary(text) and protocol in [:tel, :mailto] and is_list(opts) do
    link text, [to: "#{protocol}:#{text}"] ++ opts
  end

  def external_link(text, location, opts) when is_non_empty_binary(text) and is_non_empty_binary(location) and is_list(opts) do
    link text, [to: location, target: "_blank"] ++ opts
  end

  def external_link(_text, _protocol, _opts) do
    nil
  end

  def with_line_breaks([]) do
    nil
  end

  def with_line_breaks([content]) do
    content
  end

  def with_line_breaks([content | tail]) do
    ~E"""
      <%= content %>
      <br />
      <%= with_line_breaks(tail) %>
    """
  end

  def default_if_blank do
    "-"
  end

  def default_if_blank?(value) do
    if is_blank?(value) do
      default_if_blank()
    else
      value
    end
  end

  def is_blank?({:safe, value}) do
    is_blank?(value)
  end

  def is_blank?(value) when is_list(value) do
    Enum.all?(value, &is_blank?/1)
  end

  def is_blank?(value) when value in [nil, ""] do
    true
  end

  def is_blank?(_value) do
    false
  end
end
