defmodule VolunteerWeb.Admin.ListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias Volunteer.Infrastructure
  alias Volunteer.Permissions
  alias VolunteerWeb.UserSession
  alias VolunteerWeb.FlashHelpers
  alias VolunteerWeb.Admin.ListingParams
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]

  @preloads %{
    show: [:region, :group, :created_by, :organized_by, :approved_by],
    edit: [:region, :group, :organized_by, :approved_by],
    update: [:region, :group, :organized_by, :approved_by],
    request_approval: [:region, :group, :created_by, :organized_by],
    approve_confirmation: [],
    approve: [:region, :group, :created_by, :organized_by, :approved_by],
    unapprove: [:region, :group, :created_by, :organized_by, :approved_by],
    refresh_expiry: [:approved_by],
    expire: [],
    delete: [],
  }

  # Plugs

  plug :load_listing when action not in [:index, :new, :create]
  plug :authorize,
    action_root: [:admin, :listing],
    action_name_mapping: %{approve_confirmation: :approve},
    assigns_subject_key: :listing

  def load_listing(%Plug.Conn{params: %{"id" => id}} = conn, _opts) do
    listing =
      id
      |> Listings.get_one_admin_listing!()
      |> Repo.preload(Map.fetch!(@preloads, action_name(conn)))

    Plug.Conn.assign(conn, :listing, listing)
  end

  # Controller Actions

  def index(conn, params) do
    VolunteerWeb.Services.Analytics.track_event("Listing", "admin_index", nil, conn)

    {filter_changes, filter_data} = ListingParams.IndexFilters.changes_and_data(params["filters"])

    listings =
      Listings.get_all_admin_listings(filters: filter_data)
      |> Permissions.filter_subjects(UserSession.get_user(conn), [:admin, :listing, :show])
      |> Repo.preload([:group, :organized_by])

    render(conn, "index.html", listings: listings, filters: filter_changes)
  end

  def new(conn, _params) do
    VolunteerWeb.Services.Analytics.track_event("Listing", "admin_new", nil, conn)

    render_new_form(conn, Listings.new_listing())
  end

  def create(conn, %{"listing" => listing_params}) do
    listing_params
    |> Listings.create_listing(UserSession.get_user(conn))
    |> case do
      {:ok, listing} ->
        VolunteerWeb.Services.Analytics.track_event(
          "Listing",
          "admin_create",
          Slugify.slugify(listing),
          conn
        )

        conn
        |> FlashHelpers.put_paragraph_flash(:success, "Listing created successfully.")
        |> redirect(to: RouterHelpers.admin_listing_path(conn, :show, listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> FlashHelpers.put_paragraph_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render_new_form(changeset)
    end
  end

  def show(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    VolunteerWeb.Services.Analytics.track_event(
      "Listing",
      "admin_show",
      Slugify.slugify(listing),
      conn
    )

    render(conn, "show.html", listing: listing)
  end

  def edit(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    VolunteerWeb.Services.Analytics.track_event(
      "Listing",
      "admin_edit",
      Slugify.slugify(listing),
      conn
    )

    render_edit_form(conn, Listings.edit_listing(listing), listing)
  end

  def update(%Plug.Conn{assigns: %{listing: listing}} = conn, %{"listing" => listing_params}) do
    case Listings.update_listing(listing, listing_params) do
      {:ok, listing} ->
        VolunteerWeb.Services.Analytics.track_event(
          "Listing",
          "admin_update",
          Slugify.slugify(listing),
          conn
        )

        conn
        |> FlashHelpers.put_paragraph_flash(:success, "Listing updated successfully.")
        |> redirect(to: RouterHelpers.admin_listing_path(conn, :show, listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> FlashHelpers.put_paragraph_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render_edit_form(changeset, listing)
    end
  end

  def request_approval(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    VolunteerWeb.Services.Analytics.track_event(
      "Listing",
      "admin_request_approval",
      Slugify.slugify(listing),
      conn
    )

    Volunteer.Listings.request_approval!(listing, UserSession.get_user(conn))

    conn
    |> FlashHelpers.put_paragraph_flash(:success, "Your request for approval has been submitted for this listing.")
    |> redirect(to: RouterHelpers.admin_listing_path(conn, :show, listing))
  end

  def approve_confirmation(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    VolunteerWeb.Services.Analytics.track_event(
      "Listing",
      "admin_approve_confirmation",
      Slugify.slugify(listing),
      conn
    )

    render_approve_confirmation(conn, ListingParams.ApproveChecks.new(), listing)
  end

  def approve(%Plug.Conn{assigns: %{listing: listing}} = conn, params) do
    case ListingParams.ApproveChecks.changeset(params["checks"]) do
      %{valid?: true} ->
        if Listings.Listing.is_approved?(listing) do
          conn
          |> FlashHelpers.put_paragraph_flash(:warning, "Listing has already been approved.")
          |> redirect(to: RouterHelpers.admin_listing_path(conn, :show, listing))

        else
          listing = Listings.approve_listing_if_not_expired!(listing, UserSession.get_user(conn))

          :ok = VolunteerWeb.Services.ListingSocialImageGenerator.generate_async(conn, listing)

          VolunteerWeb.Services.Analytics.track_event(
            "Listing",
            "admin_approve",
            Slugify.slugify(listing),
            conn
          )

          conn
          |> FlashHelpers.put_paragraph_flash(:success, "Listing approved successfully.")
          |> redirect(to: RouterHelpers.admin_listing_path(conn, :show, listing))
        end

      changeset ->
        render_approve_confirmation(conn, changeset, listing)
    end
  end

  def unapprove(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    Listings.unapprove_listing_if_not_expired!(listing, UserSession.get_user(conn))

    VolunteerWeb.Services.Analytics.track_event(
      "Listing",
      "admin_unapprove",
      Slugify.slugify(listing),
      conn
    )

    conn
    |> FlashHelpers.put_paragraph_flash(:success, "Listing unapproved successfully.")
    |> redirect(to: RouterHelpers.admin_listing_path(conn, :show, listing))
  end

  def refresh_expiry(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    Listings.refresh_and_maybe_unapprove_listing!(listing)

    VolunteerWeb.Services.Analytics.track_event(
      "Listing",
      "admin_refresh_expiry",
      Slugify.slugify(listing),
      conn
    )

    conn
    |> FlashHelpers.put_paragraph_flash(:success, "Successfully refreshed listing expiry.")
    |> redirect(to: RouterHelpers.admin_listing_path(conn, :show, listing))
  end

  def expire(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    Listings.expire_listing!(listing)

    VolunteerWeb.Services.Analytics.track_event(
      "Listing",
      "admin_expire",
      Slugify.slugify(listing),
      conn
    )

    conn
    |> FlashHelpers.put_paragraph_flash(:success, "Successfully expired listing.")
    |> redirect(to: RouterHelpers.admin_listing_path(conn, :show, listing))
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
      action_path: RouterHelpers.admin_listing_path(conn, :approve, listing),
      back_path: RouterHelpers.admin_listing_path(conn, :show, listing)
    )
  end

  defp render_new_form(conn, changeset) do
    current_user_id =
      UserSession.get_user(conn)
      |> Map.get(:id)

    render_form(
      conn,
      changeset,
      "new.html",
      action_path: RouterHelpers.admin_listing_path(conn, :create),
      back_path: RouterHelpers.admin_listing_path(conn, :index),
      draft_content: Listings.Listing.draft_content(current_user_id),
      draft_content_key: VolunteerUtils.Id.generate_unique_id(12)
    )
  end

  defp render_edit_form(conn, changeset, listing) do
    render_form(
      conn,
      changeset,
      "edit.html",
      listing: listing,
      action_path: RouterHelpers.admin_listing_path(conn, :update, listing),
      back_path: RouterHelpers.admin_listing_path(conn, :show, listing)
    )
  end

  defp render_form(conn, %Ecto.Changeset{} = changeset, template, opts) do
    render(
      conn,
      template,
      opts ++
        [
          changeset: changeset,
          region_id_choices: get_region_id_choices(),
          group_id_choices: get_group_id_choices(),
          organized_by_id_choices: get_admin_user_id_choices(),
          time_commitment_type_choices: Listings.Listing.time_commitment_type_choices(),
          qualifications_required_choices: Listings.Listing.qualifications_required_choices(),
          max_char_counts: Listings.Listing.max_char_counts()
        ]
    )
  end

  defp get_region_id_choices() do
    VolunteerUtils.Controller.blank_select_choice() ++ Infrastructure.get_region_id_choices()
  end

  defp get_group_id_choices() do
    VolunteerUtils.Controller.blank_select_choice() ++ Infrastructure.get_group_id_choices()
  end

  defp get_admin_user_id_choices() do
    VolunteerUtils.Controller.blank_select_choice() ++ Volunteer.Accounts.get_admin_user_id_choices()
  end
end
