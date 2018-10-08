defmodule Volunteer.Listings.ExpiryReminder do
  alias Volunteer.Repo

  def future_expiry_to_check() do
    Volunteer.Listings.Listing.refresh_expiry_days_by() + 1
  end

  def get_and_notify_all() do
    future_expiry_date =
      Timex.now("UTC")
      |> Timex.shift(days: future_expiry_to_check())
      |> Timex.to_datetime("UTC")

    future_expiry_date
    |> Volunteer.Listings.get_all_listings_for_expiry_reminder()
    |> Repo.preload([:organized_by])
    |> Enum.map(&notify_and_update/1)
  end

  def notify_and_update(listing) do
    email =
      listing
      |> VolunteerEmail.ListingsEmails.expiry_reminder()
      # |> VolunteerEmail.Mailer.deliver_now()

    # Volunteer.Listings.expiry_reminder_sent!(listing)

    email
  end
end
