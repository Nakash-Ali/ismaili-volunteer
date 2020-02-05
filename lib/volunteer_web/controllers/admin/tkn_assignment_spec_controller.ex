defmodule VolunteerWeb.Admin.TKNAssignmentSpecController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias VolunteerWeb.UserSession
  alias VolunteerWeb.FlashHelpers
  alias VolunteerWeb.Services.SaveWebpage
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  # Plugs

  plug :load_listing
  plug :authorize,
    action_root: [:admin, :listing, :tkn],
    action_name_mapping: %{
      show: :spec,
      pdf: :spec,
      send: :spec,
    },
    assigns_subject_key: :listing
  plug :track,
    resource: "listing",
    assigns_subject_key: :listing
  plug :validate
  plug :redirect_if_not_valid

  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing =
      id
      |> Listings.get_one_admin!()
      |> Repo.preload([:created_by, :organized_by, :region, :group])

    Plug.Conn.assign(conn, :listing, listing)
  end

  def validate(%Plug.Conn{assigns: %{listing: listing}} = conn, _) do
    Plug.Conn.assign(
      conn,
      :listing_valid?,
      Listings.TKN.valid?(listing)
    )
  end

  def redirect_if_not_valid(%Plug.Conn{assigns: %{listing_valid?: true}} = conn, _) do
    conn
  end

  def redirect_if_not_valid(%Plug.Conn{assigns: %{listing_valid?: false, listing: listing}} = conn, _) do
    conn
    |> FlashHelpers.put_paragraph_flash(:error, "TKN data invalid, cannot generate Assignment Spec")
    |> Plug.Conn.put_session(:listing_invalid_redirect?, true)
    |> redirect(to: RouterHelpers.admin_listing_tkn_path(conn, :show, listing))
    |> halt
  end

  # Controller Actions

  def show(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    {:ok, tkn_country} =
      Volunteer.Infrastructure.get_region_config(listing.region_id, [:tkn, :country])

    {:ok, tkn_coordinator} =
      Volunteer.Infrastructure.get_region_config(listing.region_id, [:tkn, :coordinator])

    conn
    |> put_layout({VolunteerWeb.LayoutView, "pdf_export.html"})
    |> render(
      "show.html",
      listing: listing,
      tkn_country: tkn_country,
      tkn_coordinator: tkn_coordinator
    )
  end

  def pdf(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    redirect(
      conn,
      external: SaveWebpage.tkn_assignment_spec!(:sync, conn, listing)
    )
  end

  def send(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    Volunteer.Listings.TKN.send_tkn_assignment_spec!(
      SaveWebpage.tkn_assignment_spec!(:sync, conn, listing),
      listing,
      UserSession.get_user(conn)
    )

    conn
    |> FlashHelpers.put_paragraph_flash(:success, "The TKN Assignment Specification for this listing has been sent to your region's Associate Director for TKN!")
    |> redirect(to: RouterHelpers.admin_listing_tkn_path(conn, :show, listing))
  end
end
