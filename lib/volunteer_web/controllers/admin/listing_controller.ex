defmodule VolunteerWeb.Admin.ListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias Volunteer.Infrastructure
  alias VolunteerWeb.UtilsController
  alias VolunteerWeb.ConnPermissions

  # Plugs

  plug :load_listing
       when action not in [:index, :new, :create]

  def load_listing(%Plug.Conn{params: %{"id" => id}} = conn, _opts) do
    listing =
      id
      |> Listings.get_one_admin_listing!()
      |> preload_relations(action_name(conn))

    Plug.Conn.assign(conn, :listing, listing)
  end

  def preload_relations(listing, action) when action in [:show, :edit, :update] do
    listing |> Repo.preload(Listings.Listing.preloadables())
  end

  def preload_relations(listing, action)
      when action in [:approve, :unapprove, :refresh_expiry, :expire] do
    listing |> Repo.preload([:approved_by])
  end

  def preload_relations(listing, action) when action in [:delete] do
    listing
  end

  # Controller Actions

  def index(conn, _params) do
    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, :index])

    listings =
      case ConnPermissions.is_allowed?(conn, [:admin, :listing, :index_all]) do
        true ->
          Listings.get_all_admin_listings()

        false ->
          Listings.get_all_admin_listings_for_user(UserSession.get_user(conn))
      end
      |> Repo.preload([:group, :organized_by])

    render(conn, "index.html", listings: listings)
  end

  def new(conn, _params) do
    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, :create])
    render_form(conn, Listings.new_listing())
  end

  def create(conn, %{"listing" => listing_params}) do
    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, :create])

    listing_params
    |> Listings.create_listing(UserSession.get_user(conn))
    |> case do
      {:ok, listing} ->
        conn
        |> put_flash(:success, "Listing created successfully.")
        |> redirect(to: admin_listing_path(conn, :show, listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render_form(changeset)
    end
  end

  def show(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, :show], listing)
    render(conn, "show.html", listing: listing)
  end

  def edit(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, :update], listing)

    render_form(
      conn,
      Listings.edit_listing(listing),
      "edit.html",
      listing: listing
    )
  end

  def update(conn, %{"listing" => listing_params}) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, :update], listing)

    case Listings.update_listing(listing, listing_params) do
      {:ok, listing} ->
        conn
        |> put_flash(:success, "Listing updated successfully.")
        |> redirect(to: admin_listing_path(conn, :show, listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render_form(changeset, "edit.html", listing: listing)
    end
  end

  def approve(conn, params) do
    toggle_approval(conn, params, :approve)
  end

  def unapprove(conn, params) do
    toggle_approval(conn, params, :unapprove)
  end

  def refresh_expiry(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, :refresh_expiry], listing)
    Listings.refresh_and_maybe_unapprove_listing!(listing)

    conn
    |> put_flash(:success, "Successfully refreshed listing expiry.")
    |> redirect(to: admin_listing_path(conn, :show, listing))
  end

  def expire(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, :delete], listing)
    Listings.expire_listing!(listing)

    conn
    |> put_flash(:success, "Successfully expired listing.")
    |> redirect(to: admin_listing_path(conn, :show, listing))
  end

  def delete(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, :delete], listing)

    {:ok, _listing} = Listings.delete_listing(listing)

    conn
    |> put_flash(:success, "Listing deleted successfully.")
    |> redirect(to: admin_listing_path(conn, :index))
  end

  defp toggle_approval(conn, _params, action) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, action], listing)

    toggled_listing =
      case action do
        :approve ->
          Listings.approve_listing_if_not_expired!(listing, UserSession.get_user(conn))

        :unapprove ->
          Listings.unapprove_listing_if_not_expired!(listing)
      end

    conn
    |> put_flash(:success, "Listing #{action}ed successfully.")
    |> redirect(to: admin_listing_path(conn, :show, toggled_listing))
  end

  # Utilities

  defp render_form(conn, %Ecto.Changeset{} = changeset, template \\ "new.html", opts \\ []) do
    render(
      conn,
      template,
      opts ++
        [
          changeset: changeset,
          region_id_choices: get_region_id_choices(),
          group_id_choices: get_group_id_choices(),
          organized_by_id_choices: get_user_id_choices()
        ]
    )
  end

  defp get_region_id_choices() do
    UtilsController.blank_select_choice() ++ Infrastructure.get_region_id_choices()
  end

  defp get_group_id_choices() do
    UtilsController.blank_select_choice() ++ Infrastructure.get_group_id_choices()
  end

  defp get_user_id_choices() do
    UtilsController.blank_select_choice() ++ Volunteer.Accounts.get_user_id_choices()
  end
end
