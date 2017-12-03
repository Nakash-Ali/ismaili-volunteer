defmodule VolunteerWeb.JamatkhanaController do
  use VolunteerWeb, :controller

  alias Volunteer.Infrastructure
  alias Volunteer.Infrastructure.Jamatkhana

  def index(conn, _params) do
    jamatkhanas = Infrastructure.list_jamatkhanas()
    render(conn, "index.html", jamatkhanas: jamatkhanas)
  end

  def new(conn, _params) do
    changeset = Infrastructure.change_jamatkhana(%Jamatkhana{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"jamatkhana" => jamatkhana_params}) do
    case Infrastructure.create_jamatkhana(jamatkhana_params) do
      {:ok, jamatkhana} ->
        conn
        |> put_flash(:info, "Jamatkhana created successfully.")
        # |> redirect(to: jamatkhana_path(conn, :show, jamatkhana))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    jamatkhana = Infrastructure.get_jamatkhana!(id)
    render(conn, "show.html", jamatkhana: jamatkhana)
  end

  def edit(conn, %{"id" => id}) do
    jamatkhana = Infrastructure.get_jamatkhana!(id)
    changeset = Infrastructure.change_jamatkhana(jamatkhana)
    render(conn, "edit.html", jamatkhana: jamatkhana, changeset: changeset)
  end

  def update(conn, %{"id" => id, "jamatkhana" => jamatkhana_params}) do
    jamatkhana = Infrastructure.get_jamatkhana!(id)

    case Infrastructure.update_jamatkhana(jamatkhana, jamatkhana_params) do
      {:ok, jamatkhana} ->
        conn
        |> put_flash(:info, "Jamatkhana updated successfully.")
        # |> redirect(to: jamatkhana_path(conn, :show, jamatkhana))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", jamatkhana: jamatkhana, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    jamatkhana = Infrastructure.get_jamatkhana!(id)
    {:ok, _jamatkhana} = Infrastructure.delete_jamatkhana(jamatkhana)

    conn
    |> put_flash(:info, "Jamatkhana deleted successfully.")
    # |> redirect(to: jamatkhana_path(conn, :index))
  end
end
