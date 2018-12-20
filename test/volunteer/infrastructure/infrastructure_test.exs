defmodule Volunteer.InfrastructureTest do
  use Volunteer.DataCase

  alias Volunteer.Infrastructure

  describe "get_region_config/2" do
    test "returns correctly when data exists" do
      assert {:ok, ["cfo-announcements@iicanada.net"]} == Infrastructure.get_region_config(2, [:marketing_request, :email])
    end

    test "returns fallback when region doesn't exist" do
      assert {:ok, []} == Infrastructure.get_region_config(Faker.UUID.v4(), [:marketing_request, :email])
    end

    test "raises when key doesn't exist" do
      assert {:error, "invalid key"} == Infrastructure.get_region_config(2, Faker.UUID.v4())
    end
  end
end
