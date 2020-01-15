defmodule VolunteerWeb.Admin.TKNAssignmentSpecController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias VolunteerWeb.FlashHelpers
  alias VolunteerWeb.Services.TKNAssignmentSpecGenerator
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]

  # Plugs

  plug :load_listing
  plug :authorize,
    action_root: [:admin, :listing, :tkn],
    action_name_mapping: %{
      show: :spec,
      pdf: :spec
    },
    assigns_subject_key: :listing
  plug :validate
  plug :redirect_if_not_valid

  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing =
      id
      |> Listings.get_one_admin!()
      |> Repo.preload([:organized_by, :group])

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

  def pdf(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    disk_path =
      TKNAssignmentSpecGenerator.generate(conn, listing)

    send_download(
      conn,
      {:file, disk_path},
      filename: VolunteerWeb.Presenters.Filename.slugified(listing, "TKN Assignment Spec", "pdf"),
      charset: "utf-8"
    )
  end
end
