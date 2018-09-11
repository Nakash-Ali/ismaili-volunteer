defmodule VolunteerWeb.Admin.ApplicantController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  alias Volunteer.Listings
  alias VolunteerWeb.ConnPermissions

  # Plugs

  plug :load_listing
  plug :authorize

  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing = Listings.get_one_admin_listing!(id) |> Repo.preload([:organized_by, :group])
    Plug.Conn.assign(conn, :listing, listing)
  end

  def authorize(conn, _opts) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, :applicant], listing)
  end

  # Controller Actions

  def index(conn, _params) do
    applicants = Apply.get_all_applicants() |> Repo.preload([:user])
    render(conn, "index.html", applicants: applicants)
  end
end
