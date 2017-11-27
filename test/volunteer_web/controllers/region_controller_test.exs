defmodule VolunteerWeb.RegionControllerTest do
  use VolunteerWeb.ConnCase

  alias Volunteer.Infrastructure

  @create_attrs %{parent_path: [], title: "some title"}
  @update_attrs %{parent_path: [], title: "some updated title"}
  @invalid_attrs %{parent_path: nil, title: nil}

  def fixture(:region) do
    {:ok, region} = Infrastructure.create_region(@create_attrs)
    region
  end

  describe "index" do
    test "lists all regions", %{conn: conn} do
      conn = get conn, region_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Regions"
    end
  end

  describe "new region" do
    test "renders form", %{conn: conn} do
      conn = get conn, region_path(conn, :new)
      assert html_response(conn, 200) =~ "New Region"
    end
  end

  describe "create region" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, region_path(conn, :create), region: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == region_path(conn, :show, id)

      conn = get conn, region_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Region"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, region_path(conn, :create), region: @invalid_attrs
      assert html_response(conn, 200) =~ "New Region"
    end
  end

  describe "edit region" do
    setup [:create_region]

    test "renders form for editing chosen region", %{conn: conn, region: region} do
      conn = get conn, region_path(conn, :edit, region)
      assert html_response(conn, 200) =~ "Edit Region"
    end
  end

  describe "update region" do
    setup [:create_region]

    test "redirects when data is valid", %{conn: conn, region: region} do
      conn = put conn, region_path(conn, :update, region), region: @update_attrs
      assert redirected_to(conn) == region_path(conn, :show, region)

      conn = get conn, region_path(conn, :show, region)
      assert html_response(conn, 200) =~ "some updated title"
    end

    test "renders errors when data is invalid", %{conn: conn, region: region} do
      conn = put conn, region_path(conn, :update, region), region: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Region"
    end
  end

  describe "delete region" do
    setup [:create_region]

    test "deletes chosen region", %{conn: conn, region: region} do
      conn = delete conn, region_path(conn, :delete, region)
      assert redirected_to(conn) == region_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, region_path(conn, :show, region)
      end
    end
  end

  defp create_region(_) do
    region = fixture(:region)
    {:ok, region: region}
  end
end
