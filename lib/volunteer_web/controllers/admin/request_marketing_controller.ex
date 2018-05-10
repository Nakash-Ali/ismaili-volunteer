defmodule VolunteerWeb.Admin.RequestMarketingController do
  use VolunteerWeb, :controller
  alias Volunteer.Repo
  alias Volunteer.Apply
  alias VolunteerWeb.Authorize
  
  # Plugs

  plug :load_listing  
  plug :authorize
    
  def load_listing(%Plug.Conn{params: %{"listing_id" => id}} = conn, _opts) do
    listing = Apply.get_listing!(id)  |> Repo.preload([:organized_by, :group])
    Plug.Conn.assign(conn, :listing, listing)
  end
  
  def authorize(conn, _opts) do
    %Plug.Conn{assigns: %{listing: listing}} = conn
    Authorize.ensure_allowed!(conn, [:admin, :listing, :request_marketing], listing)
  end
  
  # Controller Actions

  # def new(conn, _params) do
  #   render_form(conn, Apply.new_tkn_listing())
  # end
  # 
  # def create(conn, %{"tkn_listing" => tkn_listing_params}) do
  #   %Plug.Conn{assigns: %{listing: listing}} = conn
  # 
  #   tkn_listing_params
  #   |> Apply.create_tkn_listing(listing)
  #   |> case do
  #     {:ok, _tkn_listing} ->
  #       IO.puts "tkn_listing created successfully, redirecting"
  #       conn
  #       |> put_flash(:info, "TKN Listing created successfully.")
  #       |> redirect(to: admin_listing_tkn_listing_path(conn, :show, listing))
  # 
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       IO.puts "tkn_listing has errors, please fix"
  #       render_form(conn, changeset)
  #   end
  # end

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
