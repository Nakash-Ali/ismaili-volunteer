defmodule VolunteerWeb.Admin.ListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  alias Volunteer.Infrastructure
  alias VolunteerWeb.UtilsController
  import VolunteerWeb.Authorize
  
  plug :validate_permissions_before_action,
    schema: Apply.Listing,
    loader: &VolunteerWeb.Admin.ListingController.load_resource/2,
    abilities: :admin
  
  def load_resource(action, %{"id" => id}) when action in [:show, :edit, :update] do
    id |> Apply.get_listing! |> Apply.preload_listing_all
  end
  
  def load_resource(action, %{"id" => id}) when action in [:approve, :unapprove] do
    id |> Apply.get_listing! |> Repo.preload([:approved_by])
  end
  
  def load_resource(_action, _params) do nil end
  
  def index(conn, _params) do
    listings = Apply.get_all_listings_created_by(Session.get_user(conn))
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
  
  def show(%Plug.Conn{assigns: %{resource: listing}} = conn, _params) do
    render(conn, "show.html", listing: listing)
  end
  
  def edit(%Plug.Conn{assigns: %{resource: listing}} = conn, _params) do
    render_form(conn, Apply.edit_listing(listing), "edit.html", listing: listing)
  end
  
  def update(%Plug.Conn{assigns: %{resource: listing}} = conn, %{"listing" => listing_params}) do
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
  
  defp toggle_approval(%Plug.Conn{assigns: %{resource: listing}} = conn, _params, action) do
    toggled_listing = case action do
      :approve -> Apply.approve_listing!(listing, Session.get_user(conn))
      :unapprove -> Apply.unapprove_listing!(listing)
    end
  
    conn
    |> put_flash(:info, "Listing #{action}ed successfully.")
    |> redirect(to: admin_listing_path(conn, :show, toggled_listing))
  end  
  
  defp render_form(conn, %Ecto.Changeset{} = changeset, template \\ "new.html", opts \\ []) do
    render(conn, template, opts ++ [
      changeset: changeset,
      group_id_choices: get_group_id_choices()
    ])
  end
  
  defp get_group_id_choices() do
    UtilsController.blank_select_choice() ++ Infrastructure.get_group_id_choices()
  end
end
