defmodule Volunteer.Listings.ExpiryReminder do
  alias Volunteer.Repo

  @future_expiry_date_shift 2

  def get_and_notify_all() do
    Enum.map(get_listings_to_notify(), &notify_and_update_listing/1)
  end

  def get_listings_to_notify() do
    future_expiry_date =
      Timex.now("UTC")
      |> Timex.shift(days: @future_expiry_date_shift)
      |> Timex.to_datetime("UTC")

    future_expiry_date
    |> Volunteer.Listings.get_all_listings_for_expiry_reminder()
    |> Repo.preload([:organized_by])
  end

  def notify_and_update_listing(listing) do
    email =
      listing
      |> VolunteerEmail.ListingsEmails.expiry_reminder()
      |> VolunteerEmail.Mailer.deliver_now()

    Volunteer.Listings.expiry_reminder_sent!(listing)

    email
  end
end
