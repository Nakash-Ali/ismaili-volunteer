defmodule VolunteerWeb.ListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  alias Volunteer.Listings

  def show(conn, %{"id" => id}) do
    listing =
      id
      |> Listings.get_one_public_listing!()
      |> Repo.preload(Listings.Listing.preloadables())

    VolunteerWeb.Services.Analytics.track_event("Listing", "show", Slugify.slugify(listing), conn)

    render_form(conn, Apply.new_applicant_with_user(), listing: listing)
  end

  def create_applicant(conn, %{"id" => id} = params) do
    listing = Listings.get_one_public_listing!(id)

    case Apply.create_applicant_with_user(listing, params["user"], params["applicant"]) do
      {:ok, _structs} ->
        conn
        |> put_flash(:info, "Applied to listing successfully.")
        |> redirect(to: index_path(conn, :index))

      {:error, changesets} ->
        render_form(conn, changesets, listing: listing)
    end
  end

  defp render_form(conn, {user_changeset, applicant_changeset}, opts) do
    render(
      conn,
      "show.html",
      opts ++
        [
          user_form: Phoenix.HTML.FormData.to_form(user_changeset, []),
          user_changeset: user_changeset,
          applicant_form: Phoenix.HTML.FormData.to_form(applicant_changeset, []),
          applicant_changeset: applicant_changeset
        ]
    )
  end
end
