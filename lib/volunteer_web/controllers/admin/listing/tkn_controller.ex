defmodule VolunteerWeb.Admin.Listing.TKNController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias VolunteerWeb.FlashHelpers
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  @preloads %{
    show: [],
    edit: [],
    update: [],
  }

  # Plugs

  plug :load_listing
  plug :authorize,
    action_root: [:admin, :listing, :tkn],
    assigns_subject_key: :listing
  plug :track,
    resource: "listing",
    assigns_subject_key: :listing
  plug :validate

  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing =
      id
      |> Listings.get_one_admin!()
      |> Repo.preload(Map.fetch!(@preloads, action_name(conn)))

    Plug.Conn.assign(conn, :listing, listing)
  end

  def validate(%Plug.Conn{assigns: %{listing: listing}} = conn, _) do
    Plug.Conn.assign(
      conn,
      :listing_valid?,
      Listings.TKN.valid?(listing)
    )
  end

  # Controller Actions

  def show(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing, listing_valid?: valid}} = conn

    listing_invalid_redirect? =
      Plug.Conn.get_session(conn, :listing_invalid_redirect?)

    conn
    |> Plug.Conn.delete_session(:listing_invalid_redirect?)
    |> render(
      "show.html",
      listing: listing,
      listing_valid?: valid,
      listing_invalid_redirect?: listing_invalid_redirect?
    )
  end

  def edit(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    changeset = Listings.TKN.edit(listing)

    render_form(
      conn,
      changeset,
      "edit.html",
      listing: listing,
      action_path: RouterHelpers.admin_listing_tkn_path(conn, :update, listing)
    )
  end

  def update(conn, %{"listing" => listing_params}) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    case Listings.TKN.update(listing, listing_params) do
      {:ok, listing} ->
        :ok = VolunteerWeb.Services.TKNAssignmentSpecGenerator.generate_async(conn, listing)

        conn
        |> FlashHelpers.put_paragraph_flash(:success, "Listing updated successfully.")
        |> redirect(to: RouterHelpers.admin_listing_tkn_path(conn, :show, listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> FlashHelpers.put_paragraph_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render_form(
          changeset,
          "edit.html",
          listing: listing,
          action_path: RouterHelpers.admin_listing_tkn_path(conn, :update, listing)
        )
    end
  end

  # Utilities

  defp render_form(conn, %Ecto.Changeset{} = changeset, template, opts) do
    render(
      conn,
      template,
      opts ++
        [
          changeset: changeset,
          listing: conn.assigns[:listing],
          back_path: RouterHelpers.admin_listing_tkn_path(conn, :show, conn.assigns[:listing]),
          classification_choices: Listings.TKN.Change.classification_choices() |> VolunteerUtils.Choices.make(%{blank: true}),
          commitment_type_choices: Listings.TKN.Change.commitment_type_choices() |> VolunteerUtils.Choices.make(%{blank: true}),
          location_type_choices: Listings.TKN.Change.location_type_choices() |> VolunteerUtils.Choices.make(%{blank: true}),
          search_scope_choices: Listings.TKN.Change.search_scope_choices() |> VolunteerUtils.Choices.make(%{blank: true}),
          function_choices: Listings.TKN.Change.function_choices() |> VolunteerUtils.Choices.make(%{blank: true}),
          industry_choices: Listings.TKN.Change.industry_choices() |> VolunteerUtils.Choices.make(%{blank: true}),
          education_level_choices: Listings.TKN.Change.education_level_choices() |> VolunteerUtils.Choices.make(%{blank: true}),
          work_experience_years_choices: Listings.TKN.Change.work_experience_years_choices() |> VolunteerUtils.Choices.make(%{blank: true}),
        ]
    )
  end
end
