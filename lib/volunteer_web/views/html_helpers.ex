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
end
