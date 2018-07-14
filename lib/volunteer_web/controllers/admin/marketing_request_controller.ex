defmodule VolunteerWeb.Admin.MarketingRequestController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  alias VolunteerWeb.Authorize
  import VolunteerWeb.SanitizeInput, only: [scrubadub_params: 2]
  
  # Plugs

  # plug :scrubadub_params, [
  #   required_key: "listing",
  #   sanitize_text_params: @text_params,
  #   sanitize_textarea_params: @textarea_params ]
  #   when action in [:create, :update]
  
  plug :load_listing
  plug :authorize
  plug :ensure_approved when action not in [:show]
    
  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing = Apply.get_listing!(id) |> Repo.preload([:organized_by, :group])
    Plug.Conn.assign(conn, :listing, listing)
  end
  
  def authorize(conn, _opts) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    Authorize.ensure_allowed!(conn, [:admin, :listing, :marketing_request], listing)
  end
  
  def ensure_approved(conn, _opts) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    case listing.approved do
      true ->
        conn
      false ->
        conn
        |> redirect(to: admin_listing_marketing_request_path(conn, :show, listing))
    end
  end
  
  # Controller Actions

  def new(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    render_form(conn, Apply.create_marketing_request(listing))
  end

  def create(conn, %{"marketing_request" => marketing_request}) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    
    listing
    |> Apply.send_marketing_request(marketing_request)
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "TKN Listing created successfully.")
        |> redirect(to: admin_listing_marketing_request_path(conn, :show, listing))
    
      {:error, %Ecto.Changeset{} = changeset} ->
        render_form(conn, changeset)
    end
  end

  def show(conn, _params) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    render(conn, "show.html", listing: listing)
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
