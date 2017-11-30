defmodule VolunteerEmail.LegacyView do
  use VolunteerEmail, :view

  def html_for_key(:email, value) do
    raw "<span class=\"mobile_link\"><a href=\"mailto:#{value}\">#{value}</a></span>"
  end

  def html_for_key(:phone, value) do
    raw "<span class=\"mobile_link\"><a href=\"tel:#{value}\">#{value}</a></span>"
  end

  def html_for_key(_, value) do
    value
  end
end
