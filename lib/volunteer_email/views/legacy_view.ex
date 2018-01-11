defmodule VolunteerEmail.LegacyView do
  use VolunteerEmail, :view

  def html_for_key(:email, value) do
    raw "<span class=\"mobile_link\"><a href=\"mailto:#{value}\">#{value}</a></span>"
  end

  def html_for_key(:phone, value) do
    raw "<span class=\"mobile_link\"><a href=\"tel:#{value}\">#{value}</a></span>"
  end

  def html_for_key(key, value) do
    text_for_key(key, value)
  end

  def text_for_key(:affirm, true) do
    "Available"
  end

  def text_for_key(:affirm, _) do
    "NOT available"
  end

  def text_for_key(_, value) when is_list(value) do
    Enum.join(value, ", ")
  end

  def text_for_key(_, value) do
    value
  end

end
