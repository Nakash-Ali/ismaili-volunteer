defmodule Volunteer.Listings.Public.ExpiryReminder do
  alias Volunteer.Repo

  @future_expiry_days_shift 3

  def future_expiry_date() do
    VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
    |> Timex.shift(days: @future_expiry_days_shift)
    |> Timex.to_datetime("UTC")
  end

  def get_and_notify_all() do
    Enum.map(get_listings_to_notify(), &notify_and_update_listing/1)
  end

  def get_listings_to_notify() do
    future_expiry_date()
    |> Volunteer.Listings.Public.get_all_for_expiry_reminder()
    |> Repo.preload(Volunteer.Listings.preloadables())
  end

  def notify_and_update_listing(listing) do
    email =
      listing
      |> VolunteerEmail.ListingsEmails.expiry_reminder()
      |> VolunteerEmail.Mailer.deliver_now!()

    Volunteer.Listings.Public.expiry_reminder_sent!(listing)

    {:ok, email}
  end
end
