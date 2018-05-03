defmodule VolunteerWeb.ListingView do
  alias Volunteer.Apply
  alias VolunteerWeb.Presenters.Title
  
  use VolunteerWeb, :view
  
  def render("head_extra.show.html", %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/listing.css")
    ]
  end
  
  def render("body_extra.show.html", assigns) do
    render(VolunteerWeb.Legacy.ListingView, "scripts.html", assigns)
  end
  
  def textarea_content(html) do
    "<div class=\"textarea-content\">#{html}</div>"
    |> Floki.parse
    |> Floki.map(fn
      {"h" <> level, attrs} when level in ["1", "2", "3", "4", "5", "6"] -> {"h5", attrs}
      {name, attrs} -> {name, attrs}
    end)
    |> Floki.raw_html
    |> raw
  end
  
  def hours_per_week_label(1) do
    "hour/week"
  end
  
  def hours_per_week_label(hours) when hours > 1 do
    "hours/week"
  end
  
  def start_date_and_end_date_html(nil, nil) do
    {:safe, "<em>On-going position starting immediately</em>"}
  end
  
  def start_date_and_end_date_html(nil, %Date{} = end_date) do
    {:safe, "<em>Starting immediately</em> to <em>#{ format_date(end_date) }</em>"}
  end
  
  def start_date_and_end_date_html(%Date{} = start_date, nil) do
    {:safe, "<em>On-going position</em> starting on <em>#{ format_date(start_date) }</em>"}
  end
  
  def start_date_and_end_date_html(%Date{} = start_date, %Date{} = end_date) do
    {:safe, "<em>#{ format_date(start_date) }</em> to <em>#{ format_date(end_date) }</em>"}
  end
  
  def format_date(%Date{} = date) do
    date
    |> Timex.format!("{D} {Mfull} {YYYY}")
  end
  
  def format_expiry(%DateTime{} = date) do
    date
    |> Timex.Timezone.convert("America/Toronto")
    |> Timex.format!("{WDfull}, {D} {Mfull} {YYYY} at {h24}:{m} ({Zabbr})")
  end
  
  def organizer_html(%Apply.Listing{} = listing) do
    {:safe, "Organized by <em>#{ Title.text(listing.organized_by) }</em> and the <em>#{ Title.text(listing.group) }</em>"}
  end
end
