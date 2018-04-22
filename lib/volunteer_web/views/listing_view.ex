defmodule VolunteerWeb.ListingView do
  alias Volunteer.Accounts
  alias Volunteer.Apply
  
  defmodule Meta do
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
    
    def title_text(%Apply.Listing{} = listing) do
      Volunteer.Apply.Listing.title(listing)
    end
    
    def title_html(%Apply.Listing{} = listing) do
      {:safe, "<strong>#{ listing.position_title }</strong>#{ Volunteer.Apply.Listing.title_suffix(listing) }"}
    end
    
    def organizer_html(%Apply.Listing{} = listing) do
      {:safe, "Organized by <em>#{ listing.organized_by.title }</em> and the <em>#{ listing.group.title }</em>"}
    end
  end
  
  defmodule Social do
    import VolunteerWeb.Router.Helpers
    
    # TODO: this module can later be refactored as the implementation
    # of the yet-to-be-written Social protocol on the Listing module
    
    def title(%Apply.Listing{} = listing) do
      "Apply now for #{Meta.title_text(listing)}!"
    end
    
    def description(%Apply.Listing{} = listing) do
      listing.summary_line
    end
    
    def image_src(%Apply.Listing{} = listing) do
      nil
    end
    
    def image_src_size(%Apply.Listing{} = listing) do
      {"", ""}
    end
    
    def image_abs_url(%Plug.Conn{} = conn, %Apply.Listing{} = listing) do
      static_url(conn, "/")
    end
    
    def popup_js(%Apply.Listing{} = _listing) do
      "window.open(this.href, '_blank', 'left=100,top=100,width=900,height=600,menubar=no,toolbar=no,resizable=yes,scrollbars=yes'); return false;"
    end
  end
  
  use VolunteerWeb, :view
  
  def render("head_extra.show.html", %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/listing.css")
    ]
  end
  
  def render("body_extra.show.html", assigns) do
    render(VolunteerWeb.Legacy.ListingView, "scripts.html", assigns)
  end
  
  def page_title(%{listing: listing}) do
    [
      "Listings",
      Meta.title_text(listing),
    ]
  end
  
  def social_tags(%{conn: conn, view_template: "show.html", listing: listing}) do
    {width, height} = Social.image_src_size(listing)
    %{
      "og:title" => Social.title(listing),
      "og:description" => Social.description(listing),
      "og:url" => listing_url(conn, :show, listing),
      "og:type" => "article",
      "og:image" => Social.image_abs_url(conn, listing),
      "og:image:width" => width,
      "og:image:height" => height,
    }
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
end
