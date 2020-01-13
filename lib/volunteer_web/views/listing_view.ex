defmodule VolunteerWeb.ListingView do
  alias Volunteer.Listings
  alias VolunteerUtils.Temporal
  alias VolunteerWeb.Presenters.{Title, Social}
  alias VolunteerWeb.FormView

  use VolunteerWeb, :view

  def render("head_extra.show.html", %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/listing.css")
    ]
  end

  def state_text_wrapper(more_classes \\ [], do: content_block) do
    ~E"""
    <p class="mb-0 py-2q px-1 font-family-sans-serif rounded text-white text-center <%= Enum.join(more_classes, " ") %>"><%= content_block %></p>
    """
  end

  def state_text_or_do(listing, %{unapproved: unapproved, expired: expired}, do: content_block) do
    cond do
      Listings.Public.Introspect.approved?(listing) == false ->
        unapproved
      Listings.Public.Introspect.expired?(listing) == true ->
        expired
      true ->
        content_block
    end
  end

  def state_text_or_social_buttons(listing, opts) do
    state_text_or_do(listing, %{
      unapproved: ~E"""
                  <%= state_text_wrapper ["bg-danger"] do %>This position is <strong>not approved</strong> by the respective board or portfolio for public distribution.<% end %>
                  """,
      expired: ~E"""
                <%= state_text_wrapper ["bg-warning"] do %>We're sorry, <strong>this position has expired</strong>. We're sure there are other opportunities for you to volunteer your time!<% end %>
                """,
    }, opts)
  end

  def state_text_or_apply(listing, opts) do
    state_text_or_do(listing, %{unapproved: nil, expired: nil}, opts)
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
    Temporal.format_date!(start_date)
  end

  def end_date_text(nil) do
    "On-going position"
  end

  def end_date_text(%Date{} = start_date) do
    Temporal.format_date!(start_date)
  end

  def start_date_and_end_date_text(nil, nil) do
    "#{end_date_text(nil)} #{start_date_text(nil) |> String.downcase}"
  end

  def start_date_and_end_date_text(nil, %Date{} = end_date) do
    "#{start_date_text(nil)} to #{end_date_text(end_date)}"
  end

  def start_date_and_end_date_text(%Date{} = start_date, nil) do
    "#{end_date_text(nil)} starting on #{start_date_text(start_date)}"
  end

  def start_date_and_end_date_text(%Date{} = start_date, %Date{} = end_date) do
    "#{start_date_text(start_date)} to #{Temporal.format_date!(end_date)}"
  end

  def expiry_datetime_text(%DateTime{} = datetime) do
    Temporal.format_datetime!(datetime)
  end

  def expires_in(%{public_expiry_date: expiry_date}) do
    Temporal.format_relative(expiry_date)
  end

  def organizer_html(%Listings.Listing{} = listing) do
    ~E"Organized by <%= Title.plain(listing.organized_by) %> and the <%= Title.plain(listing.group) %>"
  end
end
