defmodule Volunteer.InfrastructureTest do
  use Volunteer.DataCase

  alias Volunteer.Infrastructure

  describe "regions" do
    alias Volunteer.Infrastructure.Region

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def region_fixture(attrs \\ %{}) do
      {:ok, region} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Infrastructure.create_region()

      region
    end

    test "list_regions/0 returns all regions" do
      region = region_fixture()
      assert Infrastructure.list_regions() == [region]
    end

    test "get_region!/1 returns the region with given id" do
      region = region_fixture()
      assert Infrastructure.get_region!(region.id) == region
    end

    test "create_region/1 with valid data creates a region" do
      assert {:ok, %Region{} = region} = Infrastructure.create_region(@valid_attrs)
      assert region.title == "some title"
    end

    test "create_region/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Infrastructure.create_region(@invalid_attrs)
    end

    test "update_region/2 with valid data updates the region" do
      region = region_fixture()
      assert {:ok, region} = Infrastructure.update_region(region, @update_attrs)
      assert %Region{} = region
      assert region.title == "some updated title"
    end

    test "update_region/2 with invalid data returns error changeset" do
      region = region_fixture()
      assert {:error, %Ecto.Changeset{}} = Infrastructure.update_region(region, @invalid_attrs)
      assert region == Infrastructure.get_region!(region.id)
    end

    test "delete_region/1 deletes the region" do
      region = region_fixture()
      assert {:ok, %Region{}} = Infrastructure.delete_region(region)
      assert_raise Ecto.NoResultsError, fn -> Infrastructure.get_region!(region.id) end
    end

    test "change_region/1 returns a region changeset" do
      region = region_fixture()
      assert %Ecto.Changeset{} = Infrastructure.change_region(region)
    end
  end

  describe "jamatkhanas" do
    alias Volunteer.Infrastructure.Jamatkhana

    @valid_attrs %{
      address_city: "some address_city",
      address_country: "some address_country",
      address_line_1: "some address_line_1",
      address_line_2: "some address_line_2",
      address_line_3: "some address_line_3",
      address_line_4: "some address_line_4",
      address_postal_zip_code: "some address_postal_zip_code",
      address_province_state: "some address_province_state",
      title: "some title"
    }
    @update_attrs %{
      address_city: "some updated address_city",
      address_country: "some updated address_country",
      address_line_1: "some updated address_line_1",
      address_line_2: "some updated address_line_2",
      address_line_3: "some updated address_line_3",
      address_line_4: "some updated address_line_4",
      address_postal_zip_code: "some updated address_postal_zip_code",
      address_province_state: "some updated address_province_state",
      title: "some updated title"
    }
    @invalid_attrs %{
      address_city: nil,
      address_country: nil,
      address_line_1: nil,
      address_line_2: nil,
      address_line_3: nil,
      address_line_4: nil,
      address_postal_zip_code: nil,
      address_province_state: nil,
      title: nil
    }

    def jamatkhana_fixture(attrs \\ %{}) do
      {:ok, jamatkhana} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Infrastructure.create_jamatkhana()

      jamatkhana
    end

    test "list_jamatkhanas/0 returns all jamatkhanas" do
      jamatkhana = jamatkhana_fixture()
      assert Infrastructure.list_jamatkhanas() == [jamatkhana]
    end

    test "get_jamatkhana!/1 returns the jamatkhana with given id" do
      jamatkhana = jamatkhana_fixture()
      assert Infrastructure.get_jamatkhana!(jamatkhana.id) == jamatkhana
    end

    test "create_jamatkhana/1 with valid data creates a jamatkhana" do
      assert {:ok, %Jamatkhana{} = jamatkhana} = Infrastructure.create_jamatkhana(@valid_attrs)
      assert jamatkhana.address_city == "some address_city"
      assert jamatkhana.address_country == "some address_country"
      assert jamatkhana.address_line_1 == "some address_line_1"
      assert jamatkhana.address_line_2 == "some address_line_2"
      assert jamatkhana.address_line_3 == "some address_line_3"
      assert jamatkhana.address_line_4 == "some address_line_4"
      assert jamatkhana.address_postal_zip_code == "some address_postal_zip_code"
      assert jamatkhana.address_province_state == "some address_province_state"
      assert jamatkhana.title == "some title"
    end

    test "create_jamatkhana/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Infrastructure.create_jamatkhana(@invalid_attrs)
    end

    test "update_jamatkhana/2 with valid data updates the jamatkhana" do
      jamatkhana = jamatkhana_fixture()
      assert {:ok, jamatkhana} = Infrastructure.update_jamatkhana(jamatkhana, @update_attrs)
      assert %Jamatkhana{} = jamatkhana
      assert jamatkhana.address_city == "some updated address_city"
      assert jamatkhana.address_country == "some updated address_country"
      assert jamatkhana.address_line_1 == "some updated address_line_1"
      assert jamatkhana.address_line_2 == "some updated address_line_2"
      assert jamatkhana.address_line_3 == "some updated address_line_3"
      assert jamatkhana.address_line_4 == "some updated address_line_4"
      assert jamatkhana.address_postal_zip_code == "some updated address_postal_zip_code"
      assert jamatkhana.address_province_state == "some updated address_province_state"
      assert jamatkhana.title == "some updated title"
    end

    test "update_jamatkhana/2 with invalid data returns error changeset" do
      jamatkhana = jamatkhana_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Infrastructure.update_jamatkhana(jamatkhana, @invalid_attrs)

      assert jamatkhana == Infrastructure.get_jamatkhana!(jamatkhana.id)
    end

    test "delete_jamatkhana/1 deletes the jamatkhana" do
      jamatkhana = jamatkhana_fixture()
      assert {:ok, %Jamatkhana{}} = Infrastructure.delete_jamatkhana(jamatkhana)
      assert_raise Ecto.NoResultsError, fn -> Infrastructure.get_jamatkhana!(jamatkhana.id) end
    end

    test "change_jamatkhana/1 returns a jamatkhana changeset" do
      jamatkhana = jamatkhana_fixture()
      assert %Ecto.Changeset{} = Infrastructure.change_jamatkhana(jamatkhana)
    end
  end

  describe "regions" do
    alias Volunteer.Infrastructure.Region

    @valid_attrs %{path: [], title: "some title"}
    @update_attrs %{path: [], title: "some updated title"}
    @invalid_attrs %{path: nil, title: nil}

    def region_fixture(attrs \\ %{}) do
      {:ok, region} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Infrastructure.create_region()

      region
    end

    test "list_regions/0 returns all regions" do
      region = region_fixture()
      assert Infrastructure.list_regions() == [region]
    end

    test "get_region!/1 returns the region with given id" do
      region = region_fixture()
      assert Infrastructure.get_region!(region.id) == region
    end

    test "create_region/1 with valid data creates a region" do
      assert {:ok, %Region{} = region} = Infrastructure.create_region(@valid_attrs)
      assert region.path == []
      assert region.title == "some title"
    end

    test "create_region/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Infrastructure.create_region(@invalid_attrs)
    end

    test "update_region/2 with valid data updates the region" do
      region = region_fixture()
      assert {:ok, region} = Infrastructure.update_region(region, @update_attrs)
      assert %Region{} = region
      assert region.path == []
      assert region.title == "some updated title"
    end

    test "update_region/2 with invalid data returns error changeset" do
      region = region_fixture()
      assert {:error, %Ecto.Changeset{}} = Infrastructure.update_region(region, @invalid_attrs)
      assert region == Infrastructure.get_region!(region.id)
    end

    test "delete_region/1 deletes the region" do
      region = region_fixture()
      assert {:ok, %Region{}} = Infrastructure.delete_region(region)
      assert_raise Ecto.NoResultsError, fn -> Infrastructure.get_region!(region.id) end
    end

    test "change_region/1 returns a region changeset" do
      region = region_fixture()
      assert %Ecto.Changeset{} = Infrastructure.change_region(region)
    end
  end

  describe "groups" do
    alias Volunteer.Infrastructure.Group

    @valid_attrs %{parent_path: [], title: "some title"}
    @update_attrs %{parent_path: [], title: "some updated title"}
    @invalid_attrs %{parent_path: nil, title: nil}

    def group_fixture(attrs \\ %{}) do
      {:ok, group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Infrastructure.create_group()

      group
    end

    test "list_groups/0 returns all groups" do
      group = group_fixture()
      assert Infrastructure.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert Infrastructure.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      assert {:ok, %Group{} = group} = Infrastructure.create_group(@valid_attrs)
      assert group.parent_path == []
      assert group.title == "some title"
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Infrastructure.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      assert {:ok, group} = Infrastructure.update_group(group, @update_attrs)
      assert %Group{} = group
      assert group.parent_path == []
      assert group.title == "some updated title"
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Infrastructure.update_group(group, @invalid_attrs)
      assert group == Infrastructure.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Infrastructure.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Infrastructure.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Infrastructure.change_group(group)
    end
  end

  describe "regions" do
    alias Volunteer.Infrastructure.Region

    @valid_attrs %{parent_path: [], title: "some title"}
    @update_attrs %{parent_path: [], title: "some updated title"}
    @invalid_attrs %{parent_path: nil, title: nil}

    def region_fixture(attrs \\ %{}) do
      {:ok, region} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Infrastructure.create_region()

      region
    end

    test "list_regions/0 returns all regions" do
      region = region_fixture()
      assert Infrastructure.list_regions() == [region]
    end

    test "get_region!/1 returns the region with given id" do
      region = region_fixture()
      assert Infrastructure.get_region!(region.id) == region
    end

    test "create_region/1 with valid data creates a region" do
      assert {:ok, %Region{} = region} = Infrastructure.create_region(@valid_attrs)
      assert region.parent_path == []
      assert region.title == "some title"
    end

    test "create_region/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Infrastructure.create_region(@invalid_attrs)
    end

    test "update_region/2 with valid data updates the region" do
      region = region_fixture()
      assert {:ok, region} = Infrastructure.update_region(region, @update_attrs)
      assert %Region{} = region
      assert region.parent_path == []
      assert region.title == "some updated title"
    end

    test "update_region/2 with invalid data returns error changeset" do
      region = region_fixture()
      assert {:error, %Ecto.Changeset{}} = Infrastructure.update_region(region, @invalid_attrs)
      assert region == Infrastructure.get_region!(region.id)
    end

    test "delete_region/1 deletes the region" do
      region = region_fixture()
      assert {:ok, %Region{}} = Infrastructure.delete_region(region)
      assert_raise Ecto.NoResultsError, fn -> Infrastructure.get_region!(region.id) end
    end

    test "change_region/1 returns a region changeset" do
      region = region_fixture()
      assert %Ecto.Changeset{} = Infrastructure.change_region(region)
    end
  end

  describe "groups" do
    alias Volunteer.Infrastructure.Group

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def group_fixture(attrs \\ %{}) do
      {:ok, group} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Infrastructure.create_group()

      group
    end

    test "list_groups/0 returns all groups" do
      group = group_fixture()
      assert Infrastructure.list_groups() == [group]
    end

    test "get_group!/1 returns the group with given id" do
      group = group_fixture()
      assert Infrastructure.get_group!(group.id) == group
    end

    test "create_group/1 with valid data creates a group" do
      assert {:ok, %Group{} = group} = Infrastructure.create_group(@valid_attrs)
      assert group.title == "some title"
    end

    test "create_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Infrastructure.create_group(@invalid_attrs)
    end

    test "update_group/2 with valid data updates the group" do
      group = group_fixture()
      assert {:ok, group} = Infrastructure.update_group(group, @update_attrs)
      assert %Group{} = group
      assert group.title == "some updated title"
    end

    test "update_group/2 with invalid data returns error changeset" do
      group = group_fixture()
      assert {:error, %Ecto.Changeset{}} = Infrastructure.update_group(group, @invalid_attrs)
      assert group == Infrastructure.get_group!(group.id)
    end

    test "delete_group/1 deletes the group" do
      group = group_fixture()
      assert {:ok, %Group{}} = Infrastructure.delete_group(group)
      assert_raise Ecto.NoResultsError, fn -> Infrastructure.get_group!(group.id) end
    end

    test "change_group/1 returns a group changeset" do
      group = group_fixture()
      assert %Ecto.Changeset{} = Infrastructure.change_group(group)
    end
  end

  describe "regions" do
    alias Volunteer.Infrastructure.Region

    @valid_attrs %{parented_path: [], title: "some title"}
    @update_attrs %{parented_path: [], title: "some updated title"}
    @invalid_attrs %{parented_path: nil, title: nil}

    def region_fixture(attrs \\ %{}) do
      {:ok, region} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Infrastructure.create_region()

      region
    end

    test "list_regions/0 returns all regions" do
      region = region_fixture()
      assert Infrastructure.list_regions() == [region]
    end

    test "get_region!/1 returns the region with given id" do
      region = region_fixture()
      assert Infrastructure.get_region!(region.id) == region
    end

    test "create_region/1 with valid data creates a region" do
      assert {:ok, %Region{} = region} = Infrastructure.create_region(@valid_attrs)
      assert region.parented_path == []
      assert region.title == "some title"
    end

    test "create_region/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Infrastructure.create_region(@invalid_attrs)
    end

    test "update_region/2 with valid data updates the region" do
      region = region_fixture()
      assert {:ok, region} = Infrastructure.update_region(region, @update_attrs)
      assert %Region{} = region
      assert region.parented_path == []
      assert region.title == "some updated title"
    end

    test "update_region/2 with invalid data returns error changeset" do
      region = region_fixture()
      assert {:error, %Ecto.Changeset{}} = Infrastructure.update_region(region, @invalid_attrs)
      assert region == Infrastructure.get_region!(region.id)
    end

    test "delete_region/1 deletes the region" do
      region = region_fixture()
      assert {:ok, %Region{}} = Infrastructure.delete_region(region)
      assert_raise Ecto.NoResultsError, fn -> Infrastructure.get_region!(region.id) end
    end

    test "change_region/1 returns a region changeset" do
      region = region_fixture()
      assert %Ecto.Changeset{} = Infrastructure.change_region(region)
    end
  end

  describe "addresses" do
    alias Volunteer.Infrastructure.Address

    @valid_attrs %{
      city: "some city",
      code: "some code",
      country: "some country",
      line_1: "some line_1",
      line_2: "some line_2",
      line_3: "some line_3",
      line_4: "some line_4",
      region: "some region"
    }
    @update_attrs %{
      city: "some updated city",
      code: "some updated code",
      country: "some updated country",
      line_1: "some updated line_1",
      line_2: "some updated line_2",
      line_3: "some updated line_3",
      line_4: "some updated line_4",
      region: "some updated region"
    }
    @invalid_attrs %{
      city: nil,
      code: nil,
      country: nil,
      line_1: nil,
      line_2: nil,
      line_3: nil,
      line_4: nil,
      region: nil
    }

    def address_fixture(attrs \\ %{}) do
      {:ok, address} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Infrastructure.create_address()

      address
    end

    test "list_addresses/0 returns all addresses" do
      address = address_fixture()
      assert Infrastructure.list_addresses() == [address]
    end

    test "get_address!/1 returns the address with given id" do
      address = address_fixture()
      assert Infrastructure.get_address!(address.id) == address
    end

    test "create_address/1 with valid data creates a address" do
      assert {:ok, %Address{} = address} = Infrastructure.create_address(@valid_attrs)
      assert address.city == "some city"
      assert address.code == "some code"
      assert address.country == "some country"
      assert address.line_1 == "some line_1"
      assert address.line_2 == "some line_2"
      assert address.line_3 == "some line_3"
      assert address.line_4 == "some line_4"
      assert address.region == "some region"
    end

    test "create_address/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Infrastructure.create_address(@invalid_attrs)
    end

    test "update_address/2 with valid data updates the address" do
      address = address_fixture()
      assert {:ok, address} = Infrastructure.update_address(address, @update_attrs)
      assert %Address{} = address
      assert address.city == "some updated city"
      assert address.code == "some updated code"
      assert address.country == "some updated country"
      assert address.line_1 == "some updated line_1"
      assert address.line_2 == "some updated line_2"
      assert address.line_3 == "some updated line_3"
      assert address.line_4 == "some updated line_4"
      assert address.region == "some updated region"
    end

    test "update_address/2 with invalid data returns error changeset" do
      address = address_fixture()
      assert {:error, %Ecto.Changeset{}} = Infrastructure.update_address(address, @invalid_attrs)
      assert address == Infrastructure.get_address!(address.id)
    end

    test "delete_address/1 deletes the address" do
      address = address_fixture()
      assert {:ok, %Address{}} = Infrastructure.delete_address(address)
      assert_raise Ecto.NoResultsError, fn -> Infrastructure.get_address!(address.id) end
    end

    test "change_address/1 returns a address changeset" do
      address = address_fixture()
      assert %Ecto.Changeset{} = Infrastructure.change_address(address)
    end
  end

  describe "jamatkhanas" do
    alias Volunteer.Infrastructure.Jamatkhana

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def jamatkhana_fixture(attrs \\ %{}) do
      {:ok, jamatkhana} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Infrastructure.create_jamatkhana()

      jamatkhana
    end

    test "list_jamatkhanas/0 returns all jamatkhanas" do
      jamatkhana = jamatkhana_fixture()
      assert Infrastructure.list_jamatkhanas() == [jamatkhana]
    end

    test "get_jamatkhana!/1 returns the jamatkhana with given id" do
      jamatkhana = jamatkhana_fixture()
      assert Infrastructure.get_jamatkhana!(jamatkhana.id) == jamatkhana
    end

    test "create_jamatkhana/1 with valid data creates a jamatkhana" do
      assert {:ok, %Jamatkhana{} = jamatkhana} = Infrastructure.create_jamatkhana(@valid_attrs)
      assert jamatkhana.title == "some title"
    end

    test "create_jamatkhana/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Infrastructure.create_jamatkhana(@invalid_attrs)
    end

    test "update_jamatkhana/2 with valid data updates the jamatkhana" do
      jamatkhana = jamatkhana_fixture()
      assert {:ok, jamatkhana} = Infrastructure.update_jamatkhana(jamatkhana, @update_attrs)
      assert %Jamatkhana{} = jamatkhana
      assert jamatkhana.title == "some updated title"
    end

    test "update_jamatkhana/2 with invalid data returns error changeset" do
      jamatkhana = jamatkhana_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Infrastructure.update_jamatkhana(jamatkhana, @invalid_attrs)

      assert jamatkhana == Infrastructure.get_jamatkhana!(jamatkhana.id)
    end

    test "delete_jamatkhana/1 deletes the jamatkhana" do
      jamatkhana = jamatkhana_fixture()
      assert {:ok, %Jamatkhana{}} = Infrastructure.delete_jamatkhana(jamatkhana)
      assert_raise Ecto.NoResultsError, fn -> Infrastructure.get_jamatkhana!(jamatkhana.id) end
    end

    test "change_jamatkhana/1 returns a jamatkhana changeset" do
      jamatkhana = jamatkhana_fixture()
      assert %Ecto.Changeset{} = Infrastructure.change_jamatkhana(jamatkhana)
    end
  end
end
