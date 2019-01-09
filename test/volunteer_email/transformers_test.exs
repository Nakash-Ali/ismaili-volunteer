defmodule VolunteerEmail.TransformersTest do
  use ExUnit.Case
  alias VolunteerEmail.Transformers

  describe "ensure_unique_addresses/1" do
    test "filters `to` when it's just a string" do
      email = %{to: "zeb@laal.com"}
      assert ["zeb@laal.com"] == Transformers.ensure_unique_addresses(email) |> Map.get(:to)
    end

    test "filters `to` when it's a tuple" do
      email = %{to: {"Bilal", "bilal@ali.com"}}

      assert [{"Bilal", "bilal@ali.com"}] ==
               Transformers.ensure_unique_addresses(email) |> Map.get(:to)
    end

    test "complex emails" do
      email = %{
        to: {"Bilal", "bilal@ali.com"},
        cc: "bilal@ali.com",
        bcc: ["bilal@ali.com", {"Billo", "bilal@ali.com"}, "zeb@laal.com"]
      }

      transformed = Transformers.ensure_unique_addresses(email)

      assert [{"Bilal", "bilal@ali.com"}] == Map.get(transformed, :to)
      assert [] == Map.get(transformed, :cc)
      assert ["zeb@laal.com"] == Map.get(transformed, :bcc)
    end
  end
end
