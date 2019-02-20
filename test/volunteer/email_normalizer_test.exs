defmodule Volunteer.EmailNormalizerTest do
  use ExUnit.Case
  alias Volunteer.EmailNormalizer
  alias Volunteer.StringSanitizer

  defmodule Thing do
    use Ecto.Schema

    schema "things" do
      field :email, :string
      field :comma_emails, :string
      field :list_emails, {:array, :string}
    end
  end

  describe "validate and normalize email with new data" do
    test "should work" do
      changeset =
        Ecto.Changeset.cast(%Thing{}, %{email: "malikhar@me.com"}, [:email])
        |> EmailNormalizer.validate_and_normalize_change(:email)

      assert changeset.changes == %{email: "malikhar@me.com"}
      assert changeset.errors == []
    end

    test "should error on non-string value" do
      changeset =
        Ecto.Changeset.cast(%Thing{}, %{email: 1}, [:email])
        |> EmailNormalizer.validate_and_normalize_change(:email)

      assert changeset.changes == %{}
      assert changeset.errors == [email: {"is invalid", [type: :string, validation: :cast]}]
    end

    test "should ignore on nil value" do
      changeset =
        Ecto.Changeset.cast(%Thing{}, %{email: nil}, [:email])
        |> EmailNormalizer.validate_and_normalize_change(:email)

      assert changeset.changes == %{}
      assert changeset.errors == []
    end

    test "should error on non-email value" do
      changeset =
        Ecto.Changeset.cast(%Thing{}, %{email: "hahaha"}, [:email])
        |> EmailNormalizer.validate_and_normalize_change(:email)

      assert changeset.changes == %{email: "hahaha"}
      assert changeset.errors == [email: {"\"hahaha\" is not a valid email", []}]
    end
  end

  describe "validate and normalize email with updated data" do
    test "should work" do
      changeset =
        Ecto.Changeset.cast(%Thing{email: "zbaeer@me.com"}, %{email: "malikhar@me.com"}, [:email])
        |> EmailNormalizer.validate_and_normalize_change(:email)

      assert changeset.changes == %{email: "malikhar@me.com"}
      assert changeset.errors == []
    end

    test "should error on non-string value" do
      changeset =
        Ecto.Changeset.cast(%Thing{email: "zbaeer@me.com"}, %{email: 1}, [:email])
        |> EmailNormalizer.validate_and_normalize_change(:email)

      assert changeset.changes == %{}
      assert changeset.errors == [email: {"is invalid", [type: :string, validation: :cast]}]
    end

    test "should update on nil value" do
      changeset =
        Ecto.Changeset.cast(%Thing{email: "zbaeer@me.com"}, %{email: nil}, [:email])
        |> EmailNormalizer.validate_and_normalize_change(:email)

      assert changeset.changes == %{email: nil}
      assert changeset.errors == []
    end

    test "should error on non-email value" do
      changeset =
        Ecto.Changeset.cast(%Thing{email: "zbaeer@me.com"}, %{email: "hahaha"}, [:email])
        |> EmailNormalizer.validate_and_normalize_change(:email)

      assert changeset.changes == %{email: "hahaha"}
      assert changeset.errors == [email: {"\"hahaha\" is not a valid email", []}]
    end
  end

  describe "validate and normalize list of emails with new data" do
    test "should work" do
      changeset =
        Ecto.Changeset.cast(%Thing{}, %{list_emails: ["malikhar@me.com"]}, [:list_emails])
        |> EmailNormalizer.validate_and_normalize_change(:list_emails, %{type: :list})

      assert changeset.changes == %{list_emails: ["malikhar@me.com"]}
      assert changeset.errors == []
    end

    test "should error on non-list value" do
      changeset =
        Ecto.Changeset.cast(%Thing{}, %{list_emails: 1}, [:list_emails])
        |> EmailNormalizer.validate_and_normalize_change(:list_emails, %{type: :list})

      assert changeset.changes == %{}
      assert changeset.errors == [list_emails: {"is invalid", [type: {:array, :string}, validation: :cast]}]

      changeset =
        Ecto.Changeset.cast(%Thing{}, %{list_emails: "yikes"}, [:list_emails])
        |> EmailNormalizer.validate_and_normalize_change(:list_emails, %{type: :list})

      assert changeset.changes == %{}
      assert changeset.errors == [list_emails: {"is invalid", [type: {:array, :string}, validation: :cast]}]
    end

    test "should ignore on nil value" do
      changeset =
        Ecto.Changeset.cast(%Thing{}, %{list_emails: nil}, [:list_emails])
        |> EmailNormalizer.validate_and_normalize_change(:list_emails, %{type: :list})

      assert changeset.changes == %{}
      assert changeset.errors == []
    end

    test "should error on non-email values" do
      changeset =
        Ecto.Changeset.cast(%Thing{}, %{list_emails: ["hahaha", "", "       yakoob"]}, [:list_emails])
        |> EmailNormalizer.validate_and_normalize_change(:list_emails, %{type: :list})

      assert changeset.changes == %{list_emails: ["hahaha", "", "       yakoob"]}
      assert changeset.errors == [list_emails: {"\"hahaha\" is not a valid email", []}, list_emails: {"\"\" is not a valid email", []}, list_emails: {"\"       yakoob\" is not a valid email", []}]
    end

    test "should work with hetrogenous strings" do
      changeset =
        Ecto.Changeset.cast(%Thing{}, %{list_emails: ["hahaha", "", "       bulavaar@me.com", "jabuut@me.com"]}, [:list_emails])
        |> EmailNormalizer.validate_and_normalize_change(:list_emails, %{type: :list})

      assert changeset.changes == %{list_emails: ["hahaha", "", "       bulavaar@me.com", "jabuut@me.com"]}
      assert changeset.errors == [list_emails: {"\"hahaha\" is not a valid email", []}, list_emails: {"\"\" is not a valid email", []}]
    end

    test "should normalize correctly" do
      changeset =
        Ecto.Changeset.cast(%Thing{}, %{list_emails: ["jabuut@ME.COM       ", "LaLaPut@me.com", "", "       "]}, [:list_emails])
        |> StringSanitizer.sanitize_changes([:list_emails], %{type: :text})
        |> EmailNormalizer.validate_and_normalize_change(:list_emails, %{type: :list})

      assert changeset.changes == %{list_emails: ["LaLaPut@me.com", "jabuut@me.com"]}
      assert changeset.errors == []
    end
  end

  describe "validate and normalize comma separated emails" do
    test "errors correctly with new data" do
      changeset =
        Ecto.Changeset.cast(%Thing{}, %{comma_emails: "malikhar@me.com, , ,,     mooo@ME.com, ZULFIQAR@yahoo.com"}, [:comma_emails])
        |> EmailNormalizer.validate_and_normalize_change(:comma_emails, %{type: :comma_separated})

      assert changeset.changes == %{comma_emails: "malikhar@me.com, , ,,     mooo@ME.com, ZULFIQAR@yahoo.com"}
      assert changeset.errors == [comma_emails: {"\" \" is not a valid email", []}, comma_emails: {"\" \" is not a valid email", []}, comma_emails: {"\"\" is not a valid email", []}]
    end

    test "filters empty correctly with new data" do
      changeset =
        Ecto.Changeset.cast(%Thing{}, %{comma_emails: "malikhar@me.com, , ,,     mooo@ME.com, ZULFIQAR@yahoo.com"}, [:comma_emails])
        |> StringSanitizer.sanitize_changes([:comma_emails], %{type: {:comma_separated, :text}})
        |> EmailNormalizer.validate_and_normalize_change(:comma_emails, %{type: :comma_separated})

      assert changeset.changes == %{comma_emails: "ZULFIQAR@yahoo.com,mooo@me.com,malikhar@me.com"}
      assert changeset.errors == []
    end
  end
end
