defmodule VolunteerWeb.Admin.CommonView do
  use VolunteerWeb, :view
  
  def sub_title(do: html_block) do
    content_tag(:section, class: "title mb-4 text-center") do
      content_tag(:div, class: "container") do
        html_block
      end
    end
  end
end
