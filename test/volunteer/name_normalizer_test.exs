defmodule Volunteer.NameNormalizerTest do
  use ExUnit.Case
  alias Volunteer.NameNormalizer

  describe "to_titlecase/1" do
    test "leaves formatting as-is for correctly formatted names" do
      assert "Alizain Feerasta" == NameNormalizer.to_titlecase("Alizain Feerasta")
    end

    test "titlecases names with just spaces" do
      assert "Alizain Feerasta" == NameNormalizer.to_titlecase("alizain feerasta")
      assert "Alizain Feerasta" == NameNormalizer.to_titlecase("ALIZAIN FEERASTA")
      assert "Alizain Feerasta" == NameNormalizer.to_titlecase("ALiZaiN fEERAStA")
    end

    test "titlecases names with one dash" do
      assert "Zain-Manji" == NameNormalizer.to_titlecase("zain-MANJI")
      assert "Zain-Manji" == NameNormalizer.to_titlecase("ZAIN-MANJI")
    end

    test "titlecases names with two dashes" do
      assert "Zain-ul-Abadeen" == NameNormalizer.to_titlecase("Zain-ul-Abadeen")
      assert "Zain-ul-Abadeen" == NameNormalizer.to_titlecase("Zain-ul-abadeen")
      assert "Zain-ul-Abadeen" == NameNormalizer.to_titlecase("zain-ul-abadeen")
      assert "Zain-ul-Abadeen" == NameNormalizer.to_titlecase("zain-UL-aBADEEN")
    end
  end
end
