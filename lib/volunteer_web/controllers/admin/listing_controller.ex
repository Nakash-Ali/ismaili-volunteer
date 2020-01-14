defmodule VolunteerWeb.Admin.ListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias Volunteer.Infrastructure
  alias Volunteer.Permissions
  alias VolunteerWeb.UserSession
  alias VolunteerWeb.FlashHelpers
  alias VolunteerWeb.Admin.ListingParams
  import VolunteerWeb.ConnPermissions, only: [authorize: 2]
  import VolunteerWeb.Services.Analytics.Plugs, only: [track: 2]

  @preloads %{
    show: [:region, :group, :created_by, :organized_by, :public_approved_by],
    edit: [:region, :group, :organized_by, :public_approved_by],
    update: [:region, :group, :organized_by, :public_approved_by],
  }

  # Plugs

  plug :load_listing when action not in [:index, :new, :create]
  plug :authorize,
    action_root: [:admin, :listing],
    assigns_subject_key: :listing
  plug :track,
    resource: "listing",
    assigns_subject_key: :listing

  def load_listing(%Plug.Conn{params: %{"id" => id}} = conn, _opts) do
    listing =
      id
      |> Listings.get_one_admin!()
      |> Repo.preload(Map.fetch!(@preloads, action_name(conn)))

    Plug.Conn.assign(conn, :listing, listing)
  end

  # Controller Actions

  def index(conn, params) do
    {filter_changes, filter_data} = ListingParams.IndexFilters.changes_and_data(params["filters"])

    user = UserSession.get_user(conn)

    grouped_listings =
      Listings.get_all_admin(filters: filter_data)
      |> Repo.preload([:region, :group, :organized_by])
      |> Enum.reverse()
      |> Enum.reduce(%{
        created: [],
        manage: [],
        other: []
      }, fn listing, accum ->
        cond do
          listing.created_by_id == user.id ->
            %{accum | created: [listing | accum.created]}

          Permissions.is_allowed?(user, [:admin, :listing, :role, :create]) ->
            %{accum | manage: [listing | accum.manage]}

          true ->
            %{accum | other: [listing | accum.other]}
        end
      end)

    render(conn, "index.html", grouped_listings: grouped_listings, filters: filter_changes)
  end

  def new(conn, _params) do
    render_new_form(conn, Listings.new())
  end

  def create(conn, %{"listing" => listing_params}) do
    listing_params
    |> Listings.create(UserSession.get_user(conn))
    |> case do
      {:ok, listing} ->
        conn
        |> FlashHelpers.put_paragraph_flash(:success, "Listing created successfully.")
        |> redirect(to: RouterHelpers.admin_listing_path(conn, :show, listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> FlashHelpers.put_paragraph_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render_new_form(changeset)
    end
  end

  def show(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    render(conn, "show.html", listing: listing)
  end

  def edit(%Plug.Conn{assigns: %{listing: listing}} = conn, _params) do
    render_edit_form(conn, Listings.edit(listing), listing)
  end

  def update(%Plug.Conn{assigns: %{listing: listing}} = conn, %{"listing" => listing_params}) do
    case Listings.update(listing, listing_params) do
      {:ok, listing} ->
        conn
        |> FlashHelpers.put_paragraph_flash(:success, "Listing updated successfully.")
        |> redirect(to: RouterHelpers.admin_listing_path(conn, :show, listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> FlashHelpers.put_paragraph_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render_edit_form(changeset, listing)
    end
  end

  # Utilities

  defp render_new_form(conn, changeset) do
    current_user_id =
      UserSession.get_user(conn)
      |> Map.get(:id)

    render_form(
      conn,
      changeset,
      "new.html",
      action_path: RouterHelpers.admin_listing_path(conn, :create),
      back_path: RouterHelpers.admin_listing_path(conn, :index),
      draft_content: Listings.Draft.content(current_user_id),
      draft_content_key: VolunteerUtils.Id.generate_unique_id(12)
    )
  end

  defp render_edit_form(conn, changeset, listing) do
    render_form(
      conn,
      changeset,
      "edit.html",
      listing: listing,
      action_path: RouterHelpers.admin_listing_path(conn, :update, listing),
      back_path: RouterHelpers.admin_listing_path(conn, :show, listing)
    )
  end

  defp render_form(conn, %Ecto.Changeset{} = changeset, template, opts) do
    render(
      conn,
      template,
      opts ++
        [
          changeset: changeset,
          region_id_choices: get_region_id_choices(),
          group_id_choices: get_group_id_choices(),
          organized_by_id_choices: get_admin_user_id_choices(),
          time_commitment_type_choices: Listings.Change.time_commitment_type_choices(),
          qualifications_required_choices: Listings.Change.qualifications_required_choices(),
          max_char_counts: Listings.Change.max_char_counts()
        ]
    )
  end

  defp get_region_id_choices() do
    Infrastructure.get_regions() |> VolunteerUtils.Choices.make(%{blank: true})
  end

  defp get_group_id_choices() do
    Infrastructure.get_groups() |> VolunteerUtils.Choices.make(%{blank: true})
  end

  defp get_admin_user_id_choices() do
    Volunteer.Accounts.get_all_admin_users() |> VolunteerUtils.Choices.make(%{blank: true})
  end
end
