defmodule VolunteerWeb.RegionController do
  use VolunteerWeb, :controller

  alias Volunteer.Infrastructure
  alias Volunteer.Infrastructure.Region

  def index(conn, _params) do
    regions = Infrastructure.list_regions()
    render(conn, "index.html", regions: regions)
  end

  def new(conn, _params) do
    changeset = Infrastructure.change_region(%Region{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"region" => region_params}) do
    case Infrastructure.create_region(region_params) do
      {:ok, region} ->
        conn
        |> put_flash(:info, "Region created successfully.")
        # |> redirect(to: region_path(conn, :show, region))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    region = Infrastructure.get_region!(id)
    render(conn, "show.html", region: region)
  end

  def edit(conn, %{"id" => id}) do
    region = Infrastructure.get_region!(id)
    changeset = Infrastructure.change_region(region)
    render(conn, "edit.html", region: region, changeset: changeset)
  end

  def update(conn, %{"id" => id, "region" => region_params}) do
    region = Infrastructure.get_region!(id)

    case Infrastructure.update_region(region, region_params) do
      {:ok, region} ->
        conn
        |> put_flash(:info, "Region updated successfully.")
        # |> redirect(to: region_path(conn, :show, region))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", region: region, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    region = Infrastructure.get_region!(id)
    {:ok, _region} = Infrastructure.delete_region(region)

    conn
    |> put_flash(:info, "Region deleted successfully.")
    # |> redirect(to: region_path(conn, :index))
  end
end
