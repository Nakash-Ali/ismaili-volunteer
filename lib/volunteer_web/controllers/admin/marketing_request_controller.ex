defmodule VolunteerWeb.Admin.MarketingRequestController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias VolunteerWeb.ConnPermissions

  # Plugs

  plug :load_listing
  plug :ensure_listing_approved when action not in [:show]
  plug :authorize

  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing = Listings.get_one_admin_listing!(id) |> Repo.preload([:organized_by, :group])
    Plug.Conn.assign(conn, :listing, listing)
  end

  def ensure_listing_approved(conn, _opts) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    case listing.approved do
      true ->
        conn

      false ->
        conn
        |> redirect(to: RouterHelpers.admin_listing_marketing_request_path(conn, :show, listing))
    end
  end

  def authorize(conn, _opts) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, :marketing_request], listing)
  end

  # Controller Actions

  def new(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    VolunteerWeb.Services.Analytics.track_event(
      "Listing",
      "admin_marketing_request_new",
      Slugify.slugify(listing),
      conn
    )

    render_form(conn, Listings.new_marketing_request(listing))
  end

  def create(conn, %{"marketing_request" => marketing_request}) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    listing
    |> Listings.send_marketing_request(marketing_request)
    |> case do
      {:ok, _} ->
        VolunteerWeb.Services.Analytics.track_event(
          "Listing",
          "admin_marketing_request_create",
          Slugify.slugify(listing),
          conn
        )

        conn
        |> put_flash(:success, "Marketing request created successfully.")
        |> redirect(to: RouterHelpers.admin_listing_marketing_request_path(conn, :show, listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render_form(changeset)
    end
  end

  def show(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    render(conn, "show.html", listing: listing)
  end

  # Utilities

  defp render_form(conn, %Ecto.Changeset{} = changeset, template \\ "new.html", opts \\ []) do
    listing = conn.assigns[:listing]

    {:ok, jamatkhanas_for_region} =
      Volunteer.Infrastructure.get_region_config(listing.region_id, :jamatkhanas)

    render(
      conn,
      template,
      opts ++
        [
          changeset: changeset,
          listing: listing,
          jamatkhanas_for_region: jamatkhanas_for_region
        ]
    )
  end
end
