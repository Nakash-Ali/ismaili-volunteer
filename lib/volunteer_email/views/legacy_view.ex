defmodule VolunteerEmail.LegacyView do
  use VolunteerEmail, :view

  def html_for_key(:email, value) do
    raw "<span class=\"mobile_link\"><a href=\"mailto:#{value}\">#{value}</a></span>"
  end

  def html_for_key(:phone, value) do
    raw "<span class=\"mobile_link\"><a href=\"tel:#{value}\">#{value}</a></span>"
  end

  # def html_for_key(key, value) when is_list(value) do
  #   li_elements = Enum.map(value, fn val -> "<li>#{value}</li>" end) |> Enum.join("")
  #   raw "<ul>#{li_elements}</ul>"
  # end

  def html_for_key(key, value) do
    text_for_key(key, value)
  end

  def text_for_key(_, value) when is_list(value) do
    Enum.join(value, ", ")
  end

  def text_for_key(_, value) do
    value
  end

end
