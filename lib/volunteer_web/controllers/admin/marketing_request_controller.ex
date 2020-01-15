defmodule VolunteerWeb.Admin.MarketingRequestController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias Volunteer.MarketingRequests
  alias VolunteerWeb.FlashHelpers
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  @preloads %{
    new: [:group, :region],
    create: [:group, :region],
  }

  # Plugs

  plug :load_listing
  plug :authorize,
    action_root: [:admin, :listing, :marketing_request],
    assigns_subject_key: :listing
  plug :ensure_approved
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

  def ensure_approved(conn, _opts) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    if Listings.Public.Introspect.approved?(listing) do
      conn
    else
      conn
      |> FlashHelpers.put_paragraph_flash(:error, "Listing must be approved before marketing can be requested.")
      |> redirect(to: RouterHelpers.admin_listing_public_path(conn, :show, listing))
    end
  end

  # Controller Actions

  def new(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    listing_social_image =
      RouterHelpers.listing_social_image_url(conn, :png, listing)

    {:ok, config, marketing_request} =
      MarketingRequests.new(listing, %{listing_social_image: listing_social_image})

    render_form(
      conn,
      config,
      marketing_request,
      listing_social_image: listing_social_image
    )
  end

  def create(conn, %{"marketing_request" => marketing_request}) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    listing_social_image = RouterHelpers.listing_social_image_url(conn, :png, listing)

    MarketingRequests.send(listing, %{listing_social_image: listing_social_image}, marketing_request)
    |> case do
      {:ok, _config, _emails} ->
        conn
        |> FlashHelpers.put_paragraph_flash(:success, "Marketing request created successfully.")
        |> redirect(to: RouterHelpers.admin_listing_public_path(conn, :show, listing))

      {:error, config, %Ecto.Changeset{} = changeset} ->
        case VolunteerWeb.ErrorHelpers.get_underscore_errors(changeset) do
          [] ->
            conn
            |> FlashHelpers.put_paragraph_flash(:error, "Oops, something went wrong! Please check the errors below.")
            |> render_form(config, changeset, listing_social_image: listing_social_image)

          errors ->
            conn
            |> FlashHelpers.put_underscore_errors(errors)
            |> render_form(config, changeset, listing_social_image: listing_social_image, underscore_errors: errors)
        end
    end
  end

  # Utilities

  defp render_form(conn, config, %Ecto.Changeset{} = changeset, opts) do
    listing = conn.assigns[:listing]

    filestack_api_key = Application.get_env(:volunteer, :filestack) |> Keyword.fetch!(:api_key)

    render(
      conn,
      "new.html",
      opts ++
        [
          changeset: changeset,
          listing: listing,
          back_path: RouterHelpers.admin_listing_public_path(conn, :show, listing),
          action_path: RouterHelpers.admin_listing_marketing_request_path(conn, :create, listing),
          filestack_api_key: filestack_api_key,
          strategy: config.strategy,
          targets: VolunteerUtils.Choices.make(config.targets_allowed, %{blank: false}),
          targets_type: config.targets_type,
        ]
    )
  end
end
