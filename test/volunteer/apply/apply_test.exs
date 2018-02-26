defmodule Volunteer.ApplyTest do
  use Volunteer.DataCase

  alias Volunteer.Apply

  describe "listings" do
    alias Volunteer.Apply.Listing

    @valid_attrs %{approved: true, approved_date: "2010-04-17 14:00:00.000000Z", commitments: "some commitments", end_date: "some end_date", expiry_date: "2010-04-17 14:00:00.000000Z", hours_per_week: "120.5", pro_qualifications: true, program_description: "some program_description", program_title: "some program_title", qualifications: "some qualifications", responsibilities: "some responsibilities", start_date: "some start_date", summar_line: "some summar_line", title: "some title", tkn_eligible: true}
    @update_attrs %{approved: false, approved_date: "2011-05-18 15:01:01.000000Z", commitments: "some updated commitments", end_date: "some updated end_date", expiry_date: "2011-05-18 15:01:01.000000Z", hours_per_week: "456.7", pro_qualifications: false, program_description: "some updated program_description", program_title: "some updated program_title", qualifications: "some updated qualifications", responsibilities: "some updated responsibilities", start_date: "some updated start_date", summar_line: "some updated summar_line", title: "some updated title", tkn_eligible: false}
    @invalid_attrs %{approved: nil, approved_date: nil, commitments: nil, end_date: nil, expiry_date: nil, hours_per_week: nil, pro_qualifications: nil, program_description: nil, program_title: nil, qualifications: nil, responsibilities: nil, start_date: nil, summar_line: nil, title: nil, tkn_eligible: nil}

    def listing_fixture(attrs \\ %{}) do
      {:ok, listing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Apply.create_listing()

      listing
    end

    test "list_listings/0 returns all listings" do
      listing = listing_fixture()
      assert Apply.list_listings() == [listing]
    end

    test "get_listing!/1 returns the listing with given id" do
      listing = listing_fixture()
      assert Apply.get_listing!(listing.id) == listing
    end

    test "create_listing/1 with valid data creates a listing" do
      assert {:ok, %Listing{} = listing} = Apply.create_listing(@valid_attrs)
      assert listing.approved == true
      assert listing.approved_date == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert listing.commitments == "some commitments"
      assert listing.end_date == "some end_date"
      assert listing.expiry_date == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert listing.hours_per_week == Decimal.new("120.5")
      assert listing.pro_qualifications == true
      assert listing.program_description == "some program_description"
      assert listing.program_title == "some program_title"
      assert listing.qualifications == "some qualifications"
      assert listing.responsibilities == "some responsibilities"
      assert listing.start_date == "some start_date"
      assert listing.summar_line == "some summar_line"
      assert listing.title == "some title"
      assert listing.tkn_eligible == true
    end

    test "create_listing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Apply.create_listing(@invalid_attrs)
    end

    test "update_listing/2 with valid data updates the listing" do
      listing = listing_fixture()
      assert {:ok, listing} = Apply.update_listing(listing, @update_attrs)
      assert %Listing{} = listing
      assert listing.approved == false
      assert listing.approved_date == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert listing.commitments == "some updated commitments"
      assert listing.end_date == "some updated end_date"
      assert listing.expiry_date == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert listing.hours_per_week == Decimal.new("456.7")
      assert listing.pro_qualifications == false
      assert listing.program_description == "some updated program_description"
      assert listing.program_title == "some updated program_title"
      assert listing.qualifications == "some updated qualifications"
      assert listing.responsibilities == "some updated responsibilities"
      assert listing.start_date == "some updated start_date"
      assert listing.summar_line == "some updated summar_line"
      assert listing.title == "some updated title"
      assert listing.tkn_eligible == false
    end

    test "update_listing/2 with invalid data returns error changeset" do
      listing = listing_fixture()
      assert {:error, %Ecto.Changeset{}} = Apply.update_listing(listing, @invalid_attrs)
      assert listing == Apply.get_listing!(listing.id)
    end

    test "delete_listing/1 deletes the listing" do
      listing = listing_fixture()
      assert {:ok, %Listing{}} = Apply.delete_listing(listing)
      assert_raise Ecto.NoResultsError, fn -> Apply.get_listing!(listing.id) end
    end

    test "change_listing/1 returns a listing changeset" do
      listing = listing_fixture()
      assert %Ecto.Changeset{} = Apply.change_listing(listing)
    end
  end

  describe "tkn_listings" do
    alias Volunteer.Apply.TKNListing

    @valid_attrs %{openings: 42, position_category: "some position_category", position_industry: "some position_industry"}
    @update_attrs %{openings: 43, position_category: "some updated position_category", position_industry: "some updated position_industry"}
    @invalid_attrs %{openings: nil, position_category: nil, position_industry: nil}

    def tkn_listing_fixture(attrs \\ %{}) do
      {:ok, tkn_listing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Apply.create_tkn_listing()

      tkn_listing
    end

    test "list_tkn_listings/0 returns all tkn_listings" do
      tkn_listing = tkn_listing_fixture()
      assert Apply.list_tkn_listings() == [tkn_listing]
    end

    test "get_tkn_listing!/1 returns the tkn_listing with given id" do
      tkn_listing = tkn_listing_fixture()
      assert Apply.get_tkn_listing!(tkn_listing.id) == tkn_listing
    end

    test "create_tkn_listing/1 with valid data creates a tkn_listing" do
      assert {:ok, %TKNListing{} = tkn_listing} = Apply.create_tkn_listing(@valid_attrs)
      assert tkn_listing.openings == 42
      assert tkn_listing.position_category == "some position_category"
      assert tkn_listing.position_industry == "some position_industry"
    end

    test "create_tkn_listing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Apply.create_tkn_listing(@invalid_attrs)
    end

    test "update_tkn_listing/2 with valid data updates the tkn_listing" do
      tkn_listing = tkn_listing_fixture()
      assert {:ok, tkn_listing} = Apply.update_tkn_listing(tkn_listing, @update_attrs)
      assert %TKNListing{} = tkn_listing
      assert tkn_listing.openings == 43
      assert tkn_listing.position_category == "some updated position_category"
      assert tkn_listing.position_industry == "some updated position_industry"
    end

    test "update_tkn_listing/2 with invalid data returns error changeset" do
      tkn_listing = tkn_listing_fixture()
      assert {:error, %Ecto.Changeset{}} = Apply.update_tkn_listing(tkn_listing, @invalid_attrs)
      assert tkn_listing == Apply.get_tkn_listing!(tkn_listing.id)
    end

    test "delete_tkn_listing/1 deletes the tkn_listing" do
      tkn_listing = tkn_listing_fixture()
      assert {:ok, %TKNListing{}} = Apply.delete_tkn_listing(tkn_listing)
      assert_raise Ecto.NoResultsError, fn -> Apply.get_tkn_listing!(tkn_listing.id) end
    end

    test "change_tkn_listing/1 returns a tkn_listing changeset" do
      tkn_listing = tkn_listing_fixture()
      assert %Ecto.Changeset{} = Apply.change_tkn_listing(tkn_listing)
    end
  end
end
