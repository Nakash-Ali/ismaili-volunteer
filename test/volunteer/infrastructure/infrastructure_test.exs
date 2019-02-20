defmodule Volunteer.InfrastructureTest do
  use Volunteer.DataCase

  alias Volunteer.Infrastructure

  describe "get_region_config/2" do
    test "returns correctly when data exists" do
      assert {:ok, ["cfo-announcements@iicanada.net"]} ==
               Infrastructure.get_region_config(2, [:marketing_request, :email])
    end

    test "returns fallback when region doesn't exist" do
      assert {:error, "invalid region"} ==
               Infrastructure.get_region_config(Faker.UUID.v4(), [:marketing_request, :email])
    end

    test "raises when key doesn't exist" do
      assert {:error, "invalid key"} == Infrastructure.get_region_config(2, Faker.UUID.v4())
    end

    test "applies functions correctly" do
      assert {:ok,
              [
                "Barrie, Ontario",
                "Belleville, Ontario",
                "Brampton, Ontario",
                "Brantford, Ontario",
                "Don Mills, Ontario",
                "Downtown, Ontario",
                "Durham, Ontario",
                "East York, Ontario",
                "Etobicoke, Ontario",
                "Guelph, Ontario",
                "Halton, Ontario",
                "Hamilton, Ontario",
                "Headquarters, Ontario",
                "Kitchener, Ontario",
                "London, Ontario",
                "Meadowvale, Ontario",
                "Mississauga, Ontario",
                "Niagara Falls, Ontario",
                "Oshawa, Ontario",
                "Peterborough, Ontario",
                "Pickering, Ontario",
                "Richmond Hill, Ontario",
                "Scarborough, Ontario",
                "St. Thomas, Ontario",
                "Sudbury, Ontario",
                "Unionville, Ontario",
                "Willowdale, Ontario",
                "Windsor, Ontario"
              ]} == Infrastructure.get_region_config(2, :jamatkhanas)
    end
  end
end
