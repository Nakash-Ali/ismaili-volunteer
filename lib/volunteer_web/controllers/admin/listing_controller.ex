defmodule VolunteerWeb.Admin.ListingController do
  use VolunteerWeb, :controller

  alias Volunteer.Apply
  alias VolunteerWeb.Session
  alias VolunteerWeb.Router.Helpers

  def index(conn, _params) do
    listings = Apply.get_listings_for_organizer(Session.get_user(conn))
    render(conn, "index.html", listings: listings)
  end

  def new(conn, _params) do
    changeset = Apply.change_listing()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"listing" => listing_params}) do
    listing_params
    |> Utils.keys_to_atoms
    |> Apply.create_listing(1, Session.get_user(conn))
    |> case do
      {:ok, listing} ->
        conn
        |> put_flash(:info, "Listing created successfully.")
        |> redirect(to: Helpers.listing_path(conn, :show, listing))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    listing = Apply.get_listing!(id)
    render(conn, "show.html", listing: listing)
  end
  #
  # def edit(conn, %{"id" => id}) do
  #   listing = Apply.get_listing!(id)
  #   changeset = Apply.change_listing(listing)
  #   render(conn, "edit.html", listing: listing, changeset: changeset)
  # end
  #
  # def update(conn, %{"id" => id, "listing" => listing_params}) do
  #   listing = Apply.get_listing!(id)
  #
  #   case Apply.update_listing(listing, listing_params) do
  #     {:ok, listing} ->
  #       conn
  #       |> put_flash(:info, "Listing updated successfully.")
  #       # |> redirect(to: listing_path(conn, :show, listing))
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", listing: listing, changeset: changeset)
  #   end
  # end
  #
  # def delete(conn, %{"id" => id}) do
  #   listing = Apply.get_listing!(id)
  #   {:ok, _listing} = Apply.delete_listing(listing)
  #
  #   conn
  #   |> put_flash(:info, "Listing deleted successfully.")
  #   # |> redirect(to: listing_path(conn, :index))
  # end

end
