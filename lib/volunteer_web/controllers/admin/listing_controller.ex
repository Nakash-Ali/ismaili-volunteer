defmodule VolunteerWeb.Admin.ListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  alias Volunteer.Infrastructure
  alias Volunteer.Permissions.Abilities
  alias VolunteerWeb.UtilsController
  import VolunteerWeb.Authorize
  
  # Authentication & Authorization

  plug :validate_permissions_and_assign_resource,
    abilities: Abilities.Admin,
    schema: Apply.Listing,
    loader: &__MODULE__.load_resource/2,
    assign_to: :listing

  def load_resource(action, %{"id" => id}) when action in [:show, :edit, :update] do
    id |> Apply.get_listing!() |> Apply.preload_listing_all()
  end
  
  def load_resource(action, %{"id" => id}) when action in [:approve, :unapprove] do
    id |> Apply.get_listing!() |> Repo.preload([:approved_by])
  end
  
  def load_resource(_action, _params) do
    nil
  end
  
  # Controller Actions

  def index(conn, _params) do
    listings =
      case is_allowed?(conn, :admin, :index_all, Apply.Listing) do
        true ->
          Apply.get_all_listings()

        false ->
          Apply.get_all_listings_created_by(Session.get_user(conn))
      end

    render(conn, "index.html", listings: listings)
  end

  def new(conn, _params) do
    render_form(conn, Apply.new_listing())
  end

  def create(conn, %{"listing" => listing_params}) do
    listing_params
    |> Apply.create_listing(Session.get_user(conn))
    |> case do
      {:ok, listing} ->
        conn
        |> put_flash(:info, "Listing created successfully.")
        |> redirect(to: admin_listing_path(conn, :show, listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        render_form(conn, changeset)
    end
  end

  def show(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    render(conn, "show.html", listing: listing)
  end

  def edit(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    render_form(
      conn,
      Apply.edit_listing(listing),
      "edit.html",
      listing: listing
    )
  end

  def update(conn, %{"listing" => listing_params}) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    case Apply.update_listing(listing, listing_params) do
      {:ok, listing} ->
        conn
        |> put_flash(:info, "Listing updated successfully.")
        |> redirect(to: admin_listing_path(conn, :show, listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        render_form(conn, changeset, "edit.html", listing: listing)
    end
  end

  def approve(conn, params) do
    toggle_approval(conn, params, :approve)
  end

  def unapprove(conn, params) do
    toggle_approval(conn, params, :unapprove)
  end

  def delete(conn, %{"id" => id}) do
    listing = Apply.get_listing!(id)
    {:ok, _listing} = Apply.delete_listing(listing)

    conn
    |> put_flash(:info, "Listing deleted successfully.")
    |> redirect(to: admin_listing_path(conn, :index))
  end

  defp toggle_approval(conn, _params, action) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    toggled_listing =
      case action do
        :approve ->
          listing
          |> Apply.approve_listing!(Session.get_user(conn))

        :unapprove ->
          listing
          |> Apply.unapprove_listing!()
      end

    conn
    |> put_flash(:info, "Listing #{action}ed successfully.")
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
          group_id_choices: get_group_id_choices()
        ]
    )
  end

  defp get_group_id_choices() do
    UtilsController.blank_select_choice() ++ Infrastructure.get_group_id_choices()
  end
end
