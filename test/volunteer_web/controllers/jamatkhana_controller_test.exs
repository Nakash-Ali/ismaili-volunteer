defmodule VolunteerWeb.JamatkhanaControllerTest do
  use VolunteerWeb.ConnCase

  alias Volunteer.Infrastructure

  @create_attrs %{address_city: "some address_city", address_country: "some address_country", address_line_1: "some address_line_1", address_line_2: "some address_line_2", address_line_3: "some address_line_3", address_line_4: "some address_line_4", address_postal_zip_code: "some address_postal_zip_code", address_province_state: "some address_province_state", title: "some title"}
  @update_attrs %{address_city: "some updated address_city", address_country: "some updated address_country", address_line_1: "some updated address_line_1", address_line_2: "some updated address_line_2", address_line_3: "some updated address_line_3", address_line_4: "some updated address_line_4", address_postal_zip_code: "some updated address_postal_zip_code", address_province_state: "some updated address_province_state", title: "some updated title"}
  @invalid_attrs %{address_city: nil, address_country: nil, address_line_1: nil, address_line_2: nil, address_line_3: nil, address_line_4: nil, address_postal_zip_code: nil, address_province_state: nil, title: nil}

  def fixture(:jamatkhana) do
    {:ok, jamatkhana} = Infrastructure.create_jamatkhana(@create_attrs)
    jamatkhana
  end

  describe "index" do
    test "lists all jamatkhanas", %{conn: conn} do
      conn = get conn, jamatkhana_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Jamatkhanas"
    end
  end

  describe "new jamatkhana" do
    test "renders form", %{conn: conn} do
      conn = get conn, jamatkhana_path(conn, :new)
      assert html_response(conn, 200) =~ "New Jamatkhana"
    end
  end

  describe "create jamatkhana" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, jamatkhana_path(conn, :create), jamatkhana: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == jamatkhana_path(conn, :show, id)

      conn = get conn, jamatkhana_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Jamatkhana"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, jamatkhana_path(conn, :create), jamatkhana: @invalid_attrs
      assert html_response(conn, 200) =~ "New Jamatkhana"
    end
  end

  describe "edit jamatkhana" do
    setup [:create_jamatkhana]

    test "renders form for editing chosen jamatkhana", %{conn: conn, jamatkhana: jamatkhana} do
      conn = get conn, jamatkhana_path(conn, :edit, jamatkhana)
      assert html_response(conn, 200) =~ "Edit Jamatkhana"
    end
  end

  describe "update jamatkhana" do
    setup [:create_jamatkhana]

    test "redirects when data is valid", %{conn: conn, jamatkhana: jamatkhana} do
      conn = put conn, jamatkhana_path(conn, :update, jamatkhana), jamatkhana: @update_attrs
      assert redirected_to(conn) == jamatkhana_path(conn, :show, jamatkhana)

      conn = get conn, jamatkhana_path(conn, :show, jamatkhana)
      assert html_response(conn, 200) =~ "some updated address_city"
    end

    test "renders errors when data is invalid", %{conn: conn, jamatkhana: jamatkhana} do
      conn = put conn, jamatkhana_path(conn, :update, jamatkhana), jamatkhana: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Jamatkhana"
    end
  end

  describe "delete jamatkhana" do
    setup [:create_jamatkhana]

    test "deletes chosen jamatkhana", %{conn: conn, jamatkhana: jamatkhana} do
      conn = delete conn, jamatkhana_path(conn, :delete, jamatkhana)
      assert redirected_to(conn) == jamatkhana_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, jamatkhana_path(conn, :show, jamatkhana)
      end
    end
  end

  defp create_jamatkhana(_) do
    jamatkhana = fixture(:jamatkhana)
    {:ok, jamatkhana: jamatkhana}
  end
end
