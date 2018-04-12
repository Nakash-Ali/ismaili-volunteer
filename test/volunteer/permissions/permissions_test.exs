defmodule Volunteer.PermissionsTest do
  use Volunteer.DataCase

  alias Volunteer.Permissions

  describe "roles" do
    alias Volunteer.Permissions.Role

    @valid_attrs %{
      group_scope: "some group_scope",
      region_scope: "some region_scope",
      type: "some type"
    }
    @update_attrs %{
      group_scope: "some updated group_scope",
      region_scope: "some updated region_scope",
      type: "some updated type"
    }
    @invalid_attrs %{group_scope: nil, region_scope: nil, type: nil}

    def role_fixture(attrs \\ %{}) do
      {:ok, role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Permissions.create_role()

      role
    end

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Permissions.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Permissions.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Role{} = role} = Permissions.create_role(@valid_attrs)
      assert role.group_scope == "some group_scope"
      assert role.region_scope == "some region_scope"
      assert role.type == "some type"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Permissions.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, role} = Permissions.update_role(role, @update_attrs)
      assert %Role{} = role
      assert role.group_scope == "some updated group_scope"
      assert role.region_scope == "some updated region_scope"
      assert role.type == "some updated type"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Permissions.update_role(role, @invalid_attrs)
      assert role == Permissions.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Permissions.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Permissions.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Permissions.change_role(role)
    end
  end
end
