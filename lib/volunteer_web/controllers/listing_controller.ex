defmodule VolunteerWeb.ListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  alias Volunteer.Listings

  plug VolunteerWeb.Captcha, %{handle_deny: :handle_deny_captcha} when action == :create_applicant

  def handle_deny_captcha(conn, _opts) do
    conn
    |> put_flash(:error, "Captcha validation failed, please try again.")
    |> redirect(to: RouterHelpers.listing_path(conn, :show, conn.params["id"]))
    |> halt()
  end

  def load_listing(id) do
    id
    |> Listings.get_one_public_listing!()
    |> Repo.preload(Listings.Listing.preloadables())
  end

  def show(conn, %{"id" => id}) do
    listing = load_listing(id)

    VolunteerWeb.Services.Analytics.track_event("Listing", "show", Slugify.slugify(listing), conn)

    render_form(conn, Apply.new_applicant_with_user(), listing)
  end

  def create_applicant(conn, %{"id" => id} = params) do
    listing = load_listing(id)

    case Apply.create_or_update_applicant_with_user(listing, params["user"], params["applicant"]) do
      {:ok, _structs} ->
        VolunteerWeb.Services.Analytics.track_event("Listing", "apply", Slugify.slugify(listing), conn)

        conn
        |> put_flash(:info, "Congratulations, your application has been submitted!")
        |> redirect(to: RouterHelpers.index_path(conn, :index))

      {:error, changesets} ->
        render_form(conn, changesets, listing)
    end
  end

  defp render_form(conn, {user_changeset, applicant_changeset}, listing, opts \\ []) do
    render(
      conn,
      "show.html",
      opts ++
        [
          listing: listing,
          user_form: Phoenix.HTML.FormData.to_form(user_changeset, []),
          user_changeset: user_changeset,
          applicant_form: Phoenix.HTML.FormData.to_form(applicant_changeset, []),
          applicant_changeset: applicant_changeset,
          privacy_policy: Volunteer.Infrastructure.get_region_config!(listing.region_id, [:privacy_policy]),
          recaptcha_public_key: Application.fetch_env!(:recaptcha, :public_key),
          preferred_contact_choices: Volunteer.Accounts.User.preferred_contact_choices(),
          ismaili_status_choices: Volunteer.Accounts.User.ismaili_status_choices(),
          jamatkhana_choices: VolunteerUtils.Controller.blank_select_choice("N/A") ++ Volunteer.Infrastructure.jamatkhana_choices(),
          education_level_choices: VolunteerUtils.Controller.blank_select_choice() ++ (Volunteer.Accounts.User.education_level_choices() |> VolunteerUtils.Choices.transpose()),
        ]
    )
  end
end
