defmodule VolunteerWeb.ListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  alias Volunteer.Listings
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  # Plugs

  plug :load_listing
  plug :track,
    resource: "listing",
    assigns_subject_key: :listing

  def load_listing(%Plug.Conn{params: %{"id" => id}} = conn, _opts) do
    listing =
      id
      |> Listings.Public.get_one!(allow_expired: true)
      |> Repo.preload(Listings.preloadables())

    Plug.Conn.assign(conn, :listing, listing)
  end

  # Actions

  def show(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    render_form(conn, Apply.new_applicant_with_user(), listing)
  end

  def render_form(conn, {user_changeset, applicant_changeset}, listing, opts \\ []) do
    render(
      conn,
      VolunteerWeb.ListingView,
      "show.html",
      opts ++
        [
          listing: listing,
          user_form: Phoenix.HTML.FormData.to_form(user_changeset, []),
          user_changeset: user_changeset,
          applicant_form: Phoenix.HTML.FormData.to_form(applicant_changeset, []),
          applicant_changeset: applicant_changeset,
          disclaimers: Volunteer.Infrastructure.get_region_config!(listing.region_id, [:disclaimers]),
          recaptcha_public_key: Application.fetch_env!(:recaptcha, :public_key),
          preferred_contact_choices: Volunteer.Accounts.User.preferred_contact_choices(),
          ismaili_status_choices: Volunteer.Accounts.User.ismaili_status_choices(),
          jamatkhana_choices: Volunteer.Infrastructure.all_jamatkhanas() |> VolunteerUtils.Choices.make(%{blank: true}),
          education_level_choices: Volunteer.Accounts.User.education_level_choices() |> VolunteerUtils.Choices.transpose() |> VolunteerUtils.Choices.make(%{blank: true}),
        ]
    )
  end
end
