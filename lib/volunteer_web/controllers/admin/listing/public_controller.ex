defmodule VolunteerWeb.Admin.Listing.PublicController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias VolunteerWeb.UserSession
  alias VolunteerWeb.FlashHelpers
  alias VolunteerWeb.Admin.ListingParams
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  @preloads %{
    show: [:region, :group, :public_approved_by, :applicants],
    reset: [:public_approved_by],
    request_approval: [:region, :group, :created_by, :organized_by],
    approve_confirmation: [:region],
    approve: [:region, :group, :created_by, :organized_by, :public_approved_by],
    unapprove: [:region, :group, :created_by, :organized_by, :public_approved_by],
    refresh: [:region, :public_approved_by],
    expire: [:region],
  }

  # Plugs

  plug :load_listing
  plug :authorize,
    action_root: [:admin, :listing, :public],
    action_name_mapping: %{approve_confirmation: :approve},
    assigns_subject_key: :listing
  plug :track,
    resource: "listing",
    assigns_subject_key: :listing

  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing =
      id
      |> Listings.get_one_admin!()
      |> Repo.preload(Map.fetch!(@preloads, action_name(conn)))

    Plug.Conn.assign(conn, :listing, listing)
  end

  # Controller Actions

  def show(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    render(conn, "show.html", listing: listing)
  end

  def reset(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    Volunteer.Listings.Public.reset!(listing)

    conn
    |> FlashHelpers.put_paragraph_flash(:success, "Listing reset successfully.")
    |> redirect(to: RouterHelpers.admin_listing_public_path(conn, :show, listing))
  end

  def request_approval(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    Volunteer.Listings.Public.request_approval!(listing, UserSession.get_user(conn))

    conn
    |> FlashHelpers.put_paragraph_flash(:success, "Your request for approval has been submitted for this listing.")
    |> redirect(to: RouterHelpers.admin_listing_public_path(conn, :show, listing))
  end

  def approve_confirmation(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    render_approve_confirmation(conn, ListingParams.ApproveChecks.new(), listing)
  end

  def approve(%Plug.Conn{assigns: %{listing: listing}} = conn, params) do
    case ListingParams.ApproveChecks.changeset(params["checks"]) do
      %{valid?: true} ->
        listing = Listings.Public.approve!(listing, UserSession.get_user(conn))

        :ok = VolunteerWeb.Services.ListingSocialImageGenerator.generate_async(conn, listing)

        conn
        |> FlashHelpers.put_paragraph_flash(:success, "Listing approved successfully.")
        |> redirect(to: RouterHelpers.admin_listing_public_path(conn, :show, listing))

      changeset ->
        render_approve_confirmation(conn, changeset, listing)
    end
  end

  def unapprove(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    Listings.Public.unapprove!(listing, UserSession.get_user(conn))

    conn
    |> FlashHelpers.put_paragraph_flash(:success, "Listing unapproved successfully.")
    |> redirect(to: RouterHelpers.admin_listing_public_path(conn, :show, listing))
  end

  def refresh(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    case Listings.Public.refresh(listing) do
      {:ok, _listing} ->
        FlashHelpers.put_paragraph_flash(
          conn,
          :success,
          "Successfully refreshed listing expiry."
        )

      {:error, %Ecto.Changeset{} = %{errors: [public_expiry_date: {"cannot refresh, no existing expiry"}]}} ->
        FlashHelpers.put_paragraph_flash(
          conn,
          :warning,
          "Cannot refresh expiry, the listing has not been approved yet."
        )

      {:error, %Ecto.Changeset{} = %{errors: [public_expiry_date: {"cannot refresh, existing expiry newer", [days: days]}]}} ->
        FlashHelpers.put_paragraph_flash(
          conn,
          :warning,
          "Cannot refresh expiry, existing expiry is already more than #{days} days from now."
        )
    end
    |> redirect(to: RouterHelpers.admin_listing_public_path(conn, :show, listing))
  end

  def expire(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    Listings.Public.expire!(listing)

    conn
    |> FlashHelpers.put_paragraph_flash(:success, "Successfully expired listing.")
    |> redirect(to: RouterHelpers.admin_listing_public_path(conn, :show, listing))
  end

  # Utilities

  defp render_approve_confirmation(conn, changeset, listing) do
    conn
    |> put_layout({VolunteerWeb.LayoutView, "full_screen.html"})
    |> render(
      "approve_confirmation.html",
      listing: listing,
      checks: ListingParams.ApproveChecks.checks(),
      checks_changes: changeset,
      action_path: RouterHelpers.admin_listing_public_path(conn, :approve, listing),
      back_path: RouterHelpers.admin_listing_public_path(conn, :show, listing)
    )
  end
end
