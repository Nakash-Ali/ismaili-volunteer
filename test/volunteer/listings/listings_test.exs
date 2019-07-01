defmodule Volunteer.ListingsTest do
  use Volunteer.DataCase
  alias Volunteer.TestSupport.Factory

  describe "get_all_listings_for_expiry_reminder/1" do
    test "gets un-expired and un-reminded listings" do
      fields_to_validate = [
        :id,
        :expiry_date,
        :expiry_reminder_sent
      ]

      expiry_date = Faker.DateTime.forward(8)

      unexpired_and_unreminded =
        Factory.listing!(%{
          expired?: false,
          overrides: %{expiry_reminder_sent: false, expiry_date: expiry_date}
        })
        |> Map.take(fields_to_validate)

      _unexpired_and_reminded =
        Factory.listing!(%{
          expired?: false,
          overrides: %{expiry_reminder_sent: true, expiry_date: expiry_date}
        })

      _expired_and_unreminded =
        Factory.listing!(%{expired?: true, overrides: %{expiry_reminder_sent: false}})

      _expired_and_reminded =
        Factory.listing!(%{expired?: true, overrides: %{expiry_reminder_sent: true}})

      assert [] ==
               expiry_date
               |> Timex.shift(seconds: -1)
               |> Volunteer.Listings.get_all_listings_for_expiry_reminder()

      assert [unexpired_and_unreminded] ==
               expiry_date
               |> Timex.shift(seconds: 1)
               |> Volunteer.Listings.get_all_listings_for_expiry_reminder()
               |> Enum.map(&Map.take(&1, fields_to_validate))
    end
  end
end
