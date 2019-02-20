defmodule VolunteerWeb.HTMLHelpers do
  use VolunteerWeb, :view

  defguard is_non_empty_binary(text) when is_binary(text) and text != ""

  def external_link(text) when is_non_empty_binary(text) do
    external_link(text, text)
  end

  def external_link(_text) do
    nil
  end

  def external_link(text, protocol) when is_non_empty_binary(text) and protocol in [:tel, :mailto] do
    link text, to: "#{protocol}:#{text}"
  end

  def external_link(text, location) when is_non_empty_binary(text) and is_non_empty_binary(location) do
    link text, to: location, target: "_blank"
  end

  def external_link(_text, _protocol) do
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

  defguard is_blank_html(value) when value in ["", nil, [], {:safe, ""}]

  def default_if_blank do
    "-"
  end

  def default_if_blank?(value) when is_blank_html(value) do
    default_if_blank()
  end

  def default_if_blank?(value) do
    value
  end

  def is_blank?(value) when is_blank_html(value) do
    true
  end

  def is_blank?(_value) do
    false
  end
end
