defmodule VolunteerWeb.Admin.TKNAssignmentSpecController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias VolunteerWeb.ConnPermissions
  alias VolunteerWeb.Services.TKNAssignmentSpecGenerator

  # Plugs

  plug :load_tkn_listing
  plug :load_listing
  plug :redirect_to_show_if_not_exists
  plug :authorize

  def load_tkn_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    tkn_listing = Listings.get_one_tkn_listing_for_listing(id)
    Plug.Conn.assign(conn, :tkn_listing, tkn_listing)
  end

  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing = Listings.get_one_admin_listing!(id) |> Repo.preload([:organized_by, :group])
    Plug.Conn.assign(conn, :listing, listing)
  end

  def redirect_to_show_if_not_exists(conn, _) do
    %Plug.Conn{
      assigns: %{tkn_listing: tkn_listing},
      params: %{"listing_id" => listing_id}
    } = conn

    case tkn_listing do
      nil ->
        conn
        |> put_flash(:error, "TKN data does not exist, you must create it first!")
        |> redirect(to: RouterHelpers.admin_listing_tkn_listing_path(conn, :show, listing_id))

      _ ->
        conn
    end
  end

  def authorize(conn, _opts) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, :tkn_listing], listing)
  end

  # Controller Actions

  def show(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing, tkn_listing: tkn_listing}} = conn

    {:ok, tkn_country} =
      Volunteer.Infrastructure.get_region_config(listing.region_id, [:tkn, :country])

    {:ok, tkn_coordinator} =
      Volunteer.Infrastructure.get_region_config(listing.region_id, [:tkn, :coordinator])

    conn
    |> put_layout({VolunteerWeb.LayoutView, "pdf_export.html"})
    |> render(
      "show.html",
      listing: listing,
      tkn_listing: tkn_listing,
      tkn_country: tkn_country,
      tkn_coordinator: tkn_coordinator
    )
  end

  def pdf(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing, tkn_listing: tkn_listing}} = conn
    disk_path = TKNAssignmentSpecGenerator.generate!(conn, listing, tkn_listing)

    VolunteerWeb.Services.Analytics.track_event(
      "Listing",
      "tkn_assignment_spec_pdf",
      Slugify.slugify(listing),
      conn
    )

    send_download(
      conn,
      {:file, disk_path},
      filename: VolunteerWeb.Presenters.Filename.slugified(listing, "TKN Assignment Spec", "pdf"),
      charset: "utf-8"
    )
  end
end
