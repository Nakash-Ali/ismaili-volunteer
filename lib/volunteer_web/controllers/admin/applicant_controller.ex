defmodule VolunteerWeb.Admin.ApplicantController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  alias Volunteer.Listings
  alias VolunteerWeb.ConnPermissions
  import VolunteerWeb.NoRouteErrorController, only: [raise_error: 2]

  # Plugs

  plug :raise_error
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
    %Plug.Conn{assigns: %{listing: listing}} = conn

    applicants =
      listing
      |> Apply.get_all_applicants_by_listing()
      |> Repo.preload([user: [applicants: :listing]])
      |> Apply.annotate([{:user, [{:other_applicants, listing.id}]}])

    render(conn, "index.html", applicants: applicants)
  end

  def export(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    csv_content =
      listing
      |> Apply.get_all_applicants_by_listing()
      |> Repo.preload([:user])
      |> generate_csv_data()

    send_download(
      conn,
      {:binary, csv_content},
      filename: VolunteerWeb.Presenters.Filename.slugified(listing, "Applicants", "csv"),
      content_type: "text/csv",
      charset: "utf-8"
    )
  end

  def generate_csv_data(applicants) do
    Volunteer.CSV.generate(
      applicants,
      [
        {"Applicant ID", &(&1.id)},
        {"User ID", &(&1.user.id)},
        {"Created at", &(VolunteerWeb.Presenters.Temporal.format_datetime(&1.inserted_at))},
        {"Updated at", &(VolunteerWeb.Presenters.Temporal.format_datetime(&1.updated_at))},
        {"First name", &(&1.user.given_name)},
        {"Last name", &(&1.user.sur_name)},
        {"Confirm availability", &VolunteerWeb.Admin.ApplicantView.confirm_availability_text/1},
      ]
    )
  end
end
