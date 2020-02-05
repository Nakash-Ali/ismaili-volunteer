defmodule VolunteerWeb.Admin.ApplicantController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  alias Volunteer.Listings
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  # Plugs

  plug :load_listing
  plug :authorize,
    action_root: [:admin, :listing, :applicant],
    assigns_subject_key: :listing
  plug :track,
    resource: "listing",
    assigns_subject_key: :listing

  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing =
      id
      |> Listings.get_one_admin!()
      |> Repo.preload([:region])

    Plug.Conn.assign(conn, :listing, listing)
  end

  # Controller Actions

  def index(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    applicants =
      listing
      |> Apply.get_all_applicants_by_listing
      |> Apply.preload_index_ordered
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
        {"Created at", &(VolunteerUtils.Temporal.format_datetime!(&1.inserted_at))},
        {"Updated at", &(VolunteerUtils.Temporal.format_datetime!(&1.updated_at))},
        {"First name", &(&1.user.given_name)},
        {"Last name", &(&1.user.sur_name)},
        {"Confirm availability", &VolunteerWeb.Admin.ApplicantView.confirm_availability_text/1},
      ]
    )
  end
end
