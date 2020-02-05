defmodule Volunteer.Listings.Public.ExpiryReminderTest do
  use Volunteer.DataCase
  alias Volunteer.TestSupport.Factory
  alias Volunteer.TestSupport.Emails

  describe "get_listings_to_notify/0" do
    test "gets the correct listings to notify" do
      expiry_date = Timex.now("UTC")

      %{id: should_find_id} =
        Factory.listing!(%{
          expired?: false,
          approved?: true,
          overrides: %{
            public_expiry_reminder_sent: false,
            public_expiry_date: expiry_date |> Timex.shift(days: 1) |> Timex.to_datetime("UTC")
          }
        })

      _shouldnt_find =
        Factory.listing!(%{
          expired?: false,
          approved?: true,
          overrides: %{
            public_expiry_reminder_sent: false,
            public_expiry_date: expiry_date |> Timex.shift(days: 4) |> Timex.to_datetime("UTC")
          }
        })

      assert [%{id: ^should_find_id}] = Volunteer.Listings.Public.ExpiryReminder.get_listings_to_notify()
    end

    test "sends email and updates listing" do
      expiry_date = Timex.now("UTC")

      region = Factory.region!(%{overrides: %{id: 1}})

      %{id: id} =
        Factory.listing!(%{
          expired?: false,
          approved?: true,
          overrides: %{
            public_expiry_reminder_sent: false,
            public_expiry_date: expiry_date |> Timex.shift(days: 1) |> Timex.to_datetime("UTC"),
            region_id: region.id
          }
        })

      assert [{:ok, email}] = Volunteer.Listings.Public.ExpiryReminder.get_and_notify_all()

      assert id ==
               email
               |> Map.get(:assigns)
               |> Map.get(:listing)
               |> Map.get(:id)

      Emails.assert_delivered(email)

      assert true ==
               Volunteer.Listings.Listing
               |> Volunteer.Repo.get!(id)
               |> Map.get(:public_expiry_reminder_sent)
    end
  end
end
