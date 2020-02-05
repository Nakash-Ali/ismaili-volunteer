defmodule VolunteerWeb.HTMLInput do
  def sanitize!(raw_html) do
    {:ok, %{"html" => html}} =
      Volunteer.Funcs.action!("sanitize_html", %{html: raw_html})

    html
  end

  def deserialize_for_show(raw_html) do
    Phoenix.HTML.raw(raw_html)
  end

  def deserialize_for_edit(raw_html) do
    Phoenix.HTML.html_escape(raw_html)
  end
end
