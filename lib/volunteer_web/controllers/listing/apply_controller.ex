defmodule VolunteerWeb.Listing.ApplyController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  alias Volunteer.Listings
  alias VolunteerWeb.FlashHelpers
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  # Plugs

  plug :load_listing
  plug :track,
    resource: "listing",
    assigns_subject_key: :listing

  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing =
      id
      |> Listings.Public.get_one!(allow_expired: false)
      |> Repo.preload(Listings.preloadables())

    Plug.Conn.assign(conn, :listing, listing)
  end

  # Actions

  def create(conn, params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    case VolunteerWeb.Captcha.verify(conn) do
      {:ok, _} ->
        case Apply.create_or_update_applicant_with_user(listing, params["user"], params["applicant"]) do
          {:ok, _structs} ->
            conn
            |> FlashHelpers.put_structured_flash(:success, VolunteerWeb.ListingView.render("create_applicant_success_flash.html"))
            |> redirect(to: RouterHelpers.index_path(conn, :index))

          {:error, changesets} ->
            conn
            |> FlashHelpers.put_paragraph_flash(:error, "Oops, something went wrong! Please check the errors below.")
            |> VolunteerWeb.ListingController.render_form(changesets, listing)
        end

      {:error, _} ->
        conn
        |> FlashHelpers.put_paragraph_flash(:error, "Captcha validation failed, please try again.")
        |> redirect(to: RouterHelpers.listing_path(conn, :show, listing))
    end
  end
end
