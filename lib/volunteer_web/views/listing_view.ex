defmodule VolunteerWeb.ListingView do
  alias Volunteer.Listings
  alias VolunteerWeb.Presenters.{Title, Social, Temporal}

  use VolunteerWeb, :view

  def render("head_extra.show.html", %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/listing.css")
    ]
  end

  def render("body_extra.show.html", assigns) do
    render(VolunteerWeb.Legacy.ListingView, "scripts.html", assigns)
  end

  def transform_textblob_content(raw_html) do
    VolunteerWeb.HTMLInput.deserialize_for_show(raw_html)
  end

  def time_commitment_text(%{time_commitment_amount: amount, time_commitment_type: type}) do
    time_commitment_text(amount, type)
  end

  def time_commitment_text(1, "hour(s)" <> period) do
    "1 hour#{period}"
  end
  def time_commitment_text(amount, "hour(s)" <> period) when amount > 1 do
    "#{amount} hours#{period}"
  end
  def time_commitment_text(1, "day(s)" <> period) do
    "1 day#{period}"
  end
  def time_commitment_text(amount, "day(s)" <> period) when amount > 1 do
    "#{amount} days#{period}"
  end

  def start_date_text(nil) do
    "Starting immediately"
  end

  def start_date_text(%Date{} = start_date) do
    Temporal.format_date(start_date)
  end

  def end_date_text(nil) do
    "On-going position"
  end

  def end_date_text(%Date{} = start_date) do
    Temporal.format_date(start_date)
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
    ~E"<em><%= start_date_text(start_date) %></em> to <em><%=  Temporal.format_date(end_date) %></em>"
  end

  def expiry_datetime_text(%DateTime{} = datetime) do
    Temporal.format_datetime(datetime)
  end

  def expires_in(%{expiry_date: expiry_date}) do
    Temporal.format_duration_from_now(expiry_date)
  end

  def organizer_html(%Listings.Listing{} = listing) do
    ~E"Organized by <em><%= Title.text(listing.organized_by) %></em> and the <em><%= Title.text(listing.group) %></em>"
  end
end
