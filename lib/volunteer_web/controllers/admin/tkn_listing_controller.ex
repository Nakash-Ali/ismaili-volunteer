defmodule VolunteerWeb.Admin.TKNListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Listings
  alias VolunteerWeb.ConnPermissions
  alias VolunteerWeb.ControllerUtils

  # Plugs

  plug :load_tkn_listing
  plug :load_listing

  plug :redirect_to_show_if_exists
       when action in [:new, :create]

  plug :redirect_to_show_if_not_exists
       when action in [:edit, :update, :delete]

  plug :authorize

  def load_tkn_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    tkn_listing = Listings.get_one_tkn_listing_for_listing(id)
    Plug.Conn.assign(conn, :tkn_listing, tkn_listing)
  end

  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing = Listings.get_one_admin_listing!(id) |> Repo.preload([:organized_by, :group])
    Plug.Conn.assign(conn, :listing, listing)
  end

  def redirect_to_show_if_exists(conn, _) do
    %Plug.Conn{
      assigns: %{tkn_listing: tkn_listing},
      params: %{"listing_id" => listing_id}
    } = conn

    case tkn_listing do
      nil ->
        conn

      _ ->
        conn
        |> put_flash(
          :error,
          "TKN data already exists, cannot create again! To change, edit instead."
        )
        |> redirect(to: admin_listing_tkn_listing_path(conn, :show, listing_id))
    end
  end

  def redirect_to_show_if_not_exists(conn, _) do
    %Plug.Conn{
      assigns: %{tkn_listing: tkn_listing},
      params: %{"listing_id" => listing_id}
    } = conn

    case tkn_listing do
      nil ->
        conn
        |> put_flash(:error, "TKN data does not exist, you must create it first!")
        |> redirect(to: admin_listing_tkn_listing_path(conn, :show, listing_id))

      _ ->
        conn
    end
  end

  def authorize(conn, _opts) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    ConnPermissions.ensure_allowed!(conn, [:admin, :listing, :tkn_listing], listing)
  end

  # Controller Actions

  def new(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    render_form(
      conn,
      Listings.new_tkn_listing(),
      "new.html",
      action_path: admin_listing_tkn_listing_path(conn, :create, listing)
    )
  end

  def create(conn, %{"tkn_listing" => tkn_listing_params}) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    listing
    |> Listings.create_tkn_listing(tkn_listing_params)
    |> case do
      {:ok, _tkn_listing} ->
        conn
        |> put_flash(:success, "TKN Listing created successfully.")
        |> redirect(to: admin_listing_tkn_listing_path(conn, :show, listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render_form(
          changeset,
          "new.html",
          action_path: admin_listing_tkn_listing_path(conn, :create, listing)
        )
    end
  end

  def show(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    case Listings.get_one_tkn_listing_for_listing(listing.id) do
      nil ->
        render(
          conn,
          "show_none.html",
          listing: listing
        )

      tkn_listing ->
        render(
          conn,
          "show_one.html",
          listing: listing,
          tkn_listing: tkn_listing
        )
    end
  end

  def edit(conn, _params) do
    %Plug.Conn{assigns: %{tkn_listing: tkn_listing, listing: listing}} = conn
    changeset = Listings.edit_tkn_listing(tkn_listing)

    render_form(
      conn,
      changeset,
      "edit.html",
      tkn_listing: tkn_listing,
      action_path: admin_listing_tkn_listing_path(conn, :update, listing)
    )
  end

  def update(conn, %{"tkn_listing" => tkn_listing_params}) do
    %Plug.Conn{assigns: %{listing: listing, tkn_listing: tkn_listing}} = conn

    case Listings.update_tkn_listing(tkn_listing, tkn_listing_params) do
      {:ok, _tkn_listing} ->
        conn
        |> put_flash(:success, "Listing updated successfully.")
        |> redirect(to: admin_listing_tkn_listing_path(conn, :show, listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Oops, something went wrong! Please check the errors below.")
        |> render_form(
          changeset,
          "edit.html",
          tkn_listing: tkn_listing,
          action_path: admin_listing_tkn_listing_path(conn, :update, listing)
        )
    end
  end

  # def delete(conn, _paramss) do
  #   %Plug.Conn{assigns: %{listing: listing, tkn_listing: tkn_listing}} = conn
  #
  #   {:ok, _tkn_listing} = Listings.delete_tkn_listing(tkn_listing)
  #
  #   conn
  #   |> put_flash(:info, "Listing deleted successfully.")
  #   |> redirect(to: admin_listing_tkn_listing_path(conn, :show, listing))
  # end

  # Utilities

  defp render_form(conn, %Ecto.Changeset{} = changeset, template, opts) do
    render(
      conn,
      template,
      opts ++
        [
          changeset: changeset,
          listing: conn.assigns[:listing],
          back_path: admin_listing_tkn_listing_path(conn, :show, conn.assigns[:listing]),
          commitment_type_choices:
            ControllerUtils.blank_select_choice() ++ Listings.TKNListing.commitment_type_choices(),
          location_type_choices:
            ControllerUtils.blank_select_choice() ++ Listings.TKNListing.location_type_choices(),
          search_scope_choices:
            ControllerUtils.blank_select_choice() ++ Listings.TKNListing.search_scope_choices(),
          function_choices:
            ControllerUtils.blank_select_choice() ++ Listings.TKNListing.function_choices(),
          industry_choices:
            ControllerUtils.blank_select_choice() ++ Listings.TKNListing.industry_choices(),
          education_level_choices:
            ControllerUtils.blank_select_choice() ++ Listings.TKNListing.education_level_choices(),
          work_experience_level_choices:
            ControllerUtils.blank_select_choice() ++
              Listings.TKNListing.work_experience_level_choices()
        ]
    )
  end
end
