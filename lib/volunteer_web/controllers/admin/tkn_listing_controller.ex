defmodule VolunteerWeb.Admin.TKNListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Apply
  alias VolunteerWeb.Authorize
  
  # Plugs

  plug :load_listing  
  plug :authorize
  plug :load_tkn_listing_or_redirect_to_correct_id
    when action in [:show, :edit, :update, :delete]
    
  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing = Apply.get_listing!(id)
    Plug.Conn.assign(conn, :listing, listing)
  end
  
  def authorize(conn, _opts) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    Authorize.ensure_allowed!(conn, [:admin, :listing, :tkn_listing], listing)
  end
  
  defp load_tkn_listing_or_redirect_to_correct_id(conn, _) do
    %Plug.Conn{params: %{"listing_id" => listing_id, "id" => id}} = conn
    action = Phoenix.Controller.action_name(conn)
    case Apply.get_tkn_listing(id) do
      nil ->
        tkn_listing = Apply.get_tkn_listing_for_listing!(listing_id)
        redirect(conn, to: admin_listing_tkn_listing_path(conn, action, listing_id, tkn_listing))
      tkn_listing ->
        conn
        |> assign(:tkn_listing, tkn_listing)
    end
  end
  
  # Controller Actions
  
  def index(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    
    case Apply.get_tkn_listing_for_listing(listing.id) do
      nil ->
        render(
          conn,
          "index.html",
          listing: listing
        )
      
      tkn_listing ->
        redirect(
          conn,
          to: admin_listing_tkn_listing_path(conn, :show, listing, tkn_listing)
        )
    end
  end

  def new(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    case Apply.get_tkn_listing_for_listing(listing.id) do
      nil ->
        render_form(conn, Apply.new_tkn_listing())

      tkn_listing ->
        redirect(
          conn,
          to: admin_listing_tkn_listing_path(conn, :show, listing, tkn_listing)
        )
    end
  end

  def create(conn, %{"tkn_listing" => tkn_listing_params}) do
    %Plug.Conn{assigns: %{listing: listing}} = conn

    case Apply.get_tkn_listing_for_listing(listing.id) do
      nil ->
        tkn_listing_params
        |> Apply.create_tkn_listing(listing)
        |> case do
          {:ok, tkn_listing} ->
            IO.puts "tkn_listing created successfully, redirecting"
            conn
            |> put_flash(:info, "TKN Listing created successfully.")
            |> redirect(to: admin_listing_tkn_listing_path(conn, :show, listing, tkn_listing))

          {:error, %Ecto.Changeset{} = changeset} ->
            IO.puts "tkn_listing has errors, please fix"
            render_form(conn, changeset)
        end

      tkn_listing ->
        conn
        |> put_flash(:error, "Cannot create again, TKN data already exists! Try editing?")
        |> redirect(to: admin_listing_tkn_listing_path(conn, :show, listing, tkn_listing))
    end
  end

  def show(conn, _params) do
    render(
      conn,
      "show.html",
      listing: conn.assigns.listing,
      tkn_listing: conn.assigns.tkn_listing
    )
  end

  def edit(conn, _params) do
    %Plug.Conn{assigns: %{tkn_listing: tkn_listing}} = conn
    changeset = Apply.edit_tkn_listing(tkn_listing)
    render_form(conn, changeset, "edit.html", tkn_listing: tkn_listing)
  end

  def update(conn, %{"tkn_listing" => tkn_listing_params}) do
    %Plug.Conn{assigns: %{listing: listing, tkn_listing: tkn_listing}} = conn

    case Apply.update_tkn_listing(tkn_listing, tkn_listing_params) do
      {:ok, tkn_listing} ->
        conn
        |> put_flash(:info, "Listing updated successfully.")
        |> redirect(to: admin_listing_tkn_listing_path(conn, :show, listing, tkn_listing))

      {:error, %Ecto.Changeset{} = changeset} ->
        render_form(conn, changeset, "edit.html", tkn_listing: tkn_listing)
    end
  end
  
  def delete(conn, _paramss) do
    %Plug.Conn{assigns: %{listing: listing, tkn_listing: tkn_listing}} = conn
    
    {:ok, _tkn_listing} = Apply.delete_tkn_listing(tkn_listing)

    conn
    |> put_flash(:info, "Listing deleted successfully.")
    |> redirect(to: admin_listing_tkn_listing_path(conn, :index, listing))
  end
  
  # Utilities

  defp render_form(conn, %Ecto.Changeset{} = changeset, template \\ "new.html", opts \\ []) do
    render(
      conn,
      template,
      opts ++
        [
          changeset: changeset,
          listing: conn.assigns[:listing]
        ]
    )
  end
end
