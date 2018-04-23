defmodule Volunteer.AccountsTest do
  use Volunteer.DataCase

  alias Volunteer.Accounts

  describe "users" do
    alias Volunteer.Accounts.User

    @valid_attrs %{is_admin: true, title: "some title"}
    @update_attrs %{is_admin: false, title: "some updated title"}
    @invalid_attrs %{is_admin: nil, title: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.is_admin == true
      assert user.title == "some title"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.is_admin == false
      assert user.title == "some updated title"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "users" do
    alias Volunteer.Accounts.User

    @valid_attrs %{email: "some email", is_admin: true, title: "some title"}
    @update_attrs %{email: "some updated email", is_admin: false, title: "some updated title"}
    @invalid_attrs %{email: nil, is_admin: nil, title: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.is_admin == true
      assert user.title == "some title"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.is_admin == false
      assert user.title == "some updated title"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "identities" do
    alias Volunteer.Accounts.Identity

    @valid_attrs %{provider: "some provider", provider_id: "some provider_id"}
    @update_attrs %{provider: "some updated provider", provider_id: "some updated provider_id"}
    @invalid_attrs %{provider: nil, provider_id: nil}

    def identity_fixture(attrs \\ %{}) do
      {:ok, identity} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_identity()

      identity
    end

    test "list_identities/0 returns all identities" do
      identity = identity_fixture()
      assert Accounts.list_identities() == [identity]
    end

    test "get_identity!/1 returns the identity with given id" do
      identity = identity_fixture()
      assert Accounts.get_identity!(identity.id) == identity
    end

    test "create_identity/1 with valid data creates a identity" do
      assert {:ok, %Identity{} = identity} = Accounts.create_identity(@valid_attrs)
      assert identity.provider == "some provider"
      assert identity.provider_id == "some provider_id"
    end

    test "create_identity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_identity(@invalid_attrs)
    end

    test "update_identity/2 with valid data updates the identity" do
      identity = identity_fixture()
      assert {:ok, identity} = Accounts.update_identity(identity, @update_attrs)
      assert %Identity{} = identity
      assert identity.provider == "some updated provider"
      assert identity.provider_id == "some updated provider_id"
    end

    test "update_identity/2 with invalid data returns error changeset" do
      identity = identity_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_identity(identity, @invalid_attrs)
      assert identity == Accounts.get_identity!(identity.id)
    end

    test "delete_identity/1 deletes the identity" do
      identity = identity_fixture()
      assert {:ok, %Identity{}} = Accounts.delete_identity(identity)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_identity!(identity.id) end
    end

    test "change_identity/1 returns a identity changeset" do
      identity = identity_fixture()
      assert %Ecto.Changeset{} = Accounts.change_identity(identity)
    end
  end

  describe "users" do
    alias Volunteer.Accounts.User

    @valid_attrs %{
      given_name: "some given_name",
      is_admin: true,
      email: "some email",
      sur_name: "some sur_name",
      title: "some title"
    }
    @update_attrs %{
      given_name: "some updated given_name",
      is_admin: false,
      email: "some updated email",
      sur_name: "some updated sur_name",
      title: "some updated title"
    }
    @invalid_attrs %{given_name: nil, is_admin: nil, email: nil, sur_name: nil, title: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.given_name == "some given_name"
      assert user.is_admin == true
      assert user.email == "some email"
      assert user.sur_name == "some sur_name"
      assert user.title == "some title"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Accounts.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.given_name == "some updated given_name"
      assert user.is_admin == false
      assert user.email == "some updated email"
      assert user.sur_name == "some updated sur_name"
      assert user.title == "some updated title"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
