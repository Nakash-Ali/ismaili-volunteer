defmodule VolunteerWeb.ListingView do
  alias Volunteer.Apply
  alias VolunteerWeb.Presenters.{Title, Social}
  
  use VolunteerWeb, :view
  
  def render("head_extra.show.html", %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/listing.css")
    ]
  end
  
  def render("body_extra.show.html", assigns) do
    render(VolunteerWeb.Legacy.ListingView, "scripts.html", assigns)
  end
  
  def transform_textblob_content(html) do
    "<div>#{html}</div>"
    |> raw
  end
  
  def hours_per_week_label(1) do
    "hour/week"
  end
  
  def hours_per_week_label(hours) when hours > 1 do
    "hours/week"
  end
  
  def start_date_text(nil) do
    "Starting immediately"
  end
  
  def start_date_text(%Date{} = start_date) do
    format_date(start_date)
  end
  
  def end_date_text(nil) do
    "On-going position"
  end
  
  def end_date_text(%Date{} = start_date) do
    format_date(start_date)
  end
  
  def start_date_and_end_date_html(nil, nil) do
    ~E"<em><%= end_date_text(nil) %> <%= start_date_text(nil) |> String.downcase %></em>"
  end
  
  def start_date_and_end_date_html(nil, %Date{} = end_date) do
    ~E"<em><%= start_date_text(nil) %></em> to <em><%= end_date_text(end_date) %></em>"
  end
  
  def start_date_and_end_date_html(%Date{} = start_date, nil) do
    ~E"<em><%= end_date_text(nil) %></em> starting on <em><%= start_date_text(start_date) %></em>"
  end
  
  def start_date_and_end_date_html(%Date{} = start_date, %Date{} = end_date) do
    ~E"<em><%= start_date_text(start_date) %></em> to <em><%=  format_date(end_date) %></em>"
  end

  def expiry_datetime_text(%DateTime{} = datetime) do
    format_datetime(datetime)
  end
  
  def format_date(%Date{} = date) do
    date
    |> Timex.format!("{D} {Mfull} {YYYY}")
  end
  
  def format_datetime(%DateTime{} = datetime) do
    datetime
    |> Timex.Timezone.convert("America/Toronto")
    |> Timex.format!("{WDfull}, {D} {Mfull} {YYYY} at {h24}:{m} ({Zabbr})")
  end
  
  def organizer_html(%Apply.Listing{} = listing) do
    ~E"Organized by <em><%= Title.text(listing.organized_by) %></em> and the <em><%= Title.text(listing.group) %></em>"
  end
end
