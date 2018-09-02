defmodule VolunteerWeb.Admin.ListingView do
  use VolunteerWeb, :view
  alias VolunteerWeb.FormView
  alias VolunteerWeb.ListingView, as: PublicListingView
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.Presenters.Title

  def render("head_extra" <> page, %{conn: conn}) when page in [".edit.html", ".new.html"] do
    [
      render(VolunteerWeb.VendorView, "choices.html"),
      render(VolunteerWeb.VendorView, "trix.html"),
      stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def render("head_extra" <> _, %{conn: conn}) do
    [
      stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  def sub_title_nav(%{conn: conn, listing: listing, active_nav: active_nav}) do
    [
      {"Info", admin_listing_path(conn, :show, listing)},
      {"TKN", admin_listing_tkn_listing_path(conn, :show, listing)},
      {"Marketing", admin_listing_marketing_request_path(conn, :show, listing)}
    ]
    |> Enum.map(fn {title, path} ->
      case String.downcase(title) do
        ^active_nav ->
          {title, path, "active"}

        _ ->
          {title, path, ""}
      end
    end)
  end

  def listing_state_text_and_class(listing) do
    if Volunteer.Apply.Listing.is_expired?(listing) do
      {"Expired and archived", "text-danger"}
    else
      if Volunteer.Apply.Listing.is_approved?(listing) do
        {"Approved and alive", "text-success"}
      else
        {"Waiting for approval", "text-warning"}
      end
    end
  end
end
