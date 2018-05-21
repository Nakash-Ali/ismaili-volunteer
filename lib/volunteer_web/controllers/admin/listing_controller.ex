defmodule VolunteerWeb.Admin.ListingController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  alias Volunteer.Infrastructure
  alias VolunteerWeb.UtilsController
  alias VolunteerWeb.Authorize
  alias VolunteerWeb.Services.ListingSocialImageGenerator
  import VolunteerWeb.SanitizeInput, only: [scrubadub_params: 2]
  
  @text_params [
    "position_title",
    "program_title",
    "summary_line"
  ]
  
  @textarea_params [
    "program_description",
    "qualifications",
    "responsibilities",
  ]
  
  # Plugs

  plug :scrubadub_params, [
    required_key: "listing",
    sanitize_text_params: @text_params,
    sanitize_textarea_params: @textarea_params ]
    when action in [:create, :update]
  
  plug :load_listing
    when action in [:show, :edit, :update, :approve, :unapprove, :refresh_expiry]

  def load_listing(%Plug.Conn{params: %{"id" => id}} = conn, _opts) do
    listing =
      id
      |> Apply.get_listing!()
      |> preload_relations(action_name(conn))
    Plug.Conn.assign(conn, :listing, listing)
  end
  
  def preload_relations(listing, action) when action in [:show, :edit, :update] do
    listing |> Repo.preload(Apply.Listing.preloadables())
  end
  
  def preload_relations(listing, action) when action in [:approve, :unapprove] do
    listing |> Repo.preload([:approved_by])
  end
  
  def preload_relations(listing, action) when action in [:refresh_expiry] do
    listing
  end
  
  # Controller Actions

  def index(conn, _params) do
    Authorize.ensure_allowed!(conn, [:admin, :listing, :index])
    
    listings =
      case Authorize.is_allowed?(conn, [:admin, :listing, :index_all]) do
        true ->
          Apply.get_all_listings()

        false ->
          Apply.get_all_listings_for_user(Session.get_user(conn))
      end
      |> Repo.preload([:group, :organized_by])

    render(conn, "index.html", listings: listings)
  end

  def new(conn, _params) do
    Authorize.ensure_allowed!(conn, [:admin, :listing, :create])
    render_form(conn, Apply.new_listing())
  end

  def create(conn, %{"listing" => listing_params}) do
    Authorize.ensure_allowed!(conn, [:admin, :listing, :create])
    
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
    Authorize.ensure_allowed!(conn, [:admin, :listing, :show], listing)
    render(conn, "show.html", listing: listing)
  end

  def edit(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    
    Authorize.ensure_allowed!(conn, [:admin, :listing, :update], listing)

    render_form(
      conn,
      Apply.edit_listing(listing),
      "edit.html",
      listing: listing
    )
  end

  def update(conn, %{"listing" => listing_params}) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    
    Authorize.ensure_allowed!(conn, [:admin, :listing, :update], listing)
    
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
  
  def refresh_expiry(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    
    Authorize.ensure_allowed!(conn, [:admin, :listing, :refresh_expiry], listing)
    Apply.refresh_expiry_for_listing!(listing)
    
    conn
    |> put_flash(:info, "Successfully refreshed listing expiry.")
    |> redirect(to: admin_listing_path(conn, :show, listing))
  end
  
  def expire(conn, params) do
    conn
  end

  def delete(conn, %{"id" => id}) do
    listing = Apply.get_listing!(id)
  
    Authorize.ensure_allowed!(conn, [:admin, :listing, :delete], listing)
  
    {:ok, _listing} = Apply.delete_listing(listing)
  
    conn
    |> put_flash(:info, "Listing deleted successfully.")
    |> redirect(to: admin_listing_path(conn, :index))
  end

  defp toggle_approval(conn, _params, action) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    
    Authorize.ensure_allowed!(conn, [:admin, :listing, action], listing)

    toggled_listing =
      case action do
        :approve ->
          toggled_listing =
            Apply.approve_listing!(listing, Session.get_user(conn))
          
          ListingSocialImageGenerator.generate_image_async(conn, toggled_listing)
          
          toggled_listing

        :unapprove ->
          Apply.unapprove_listing!(listing)
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
