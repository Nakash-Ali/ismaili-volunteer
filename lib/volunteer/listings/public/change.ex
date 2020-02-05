defmodule Volunteer.Listings.Public.Change do
  import Ecto.Changeset
  alias Volunteer.Accounts.User

  @initial_expiry_days 25
  @refresh_expiry_days 10

  # NOTE: This must only be used for when the listing has is expired, regardless
  # of whether the expiry was due to natural causes or human intervention!
  def reset(listing) do
    listing
    |> unapprove
  end

  def approve(listing, %User{} = approved_by) do
    listing
    |> change()
    |> put_change(:public_approved, true)
    |> put_change(:public_approved_on, VolunteerUtils.Temporal.utc_now_truncated_to_seconds())
    |> put_assoc(:public_approved_by, approved_by)
    |> foreign_key_constraint(:public_approved_by_id)
    |> initial_expiry()
  end

  def unapprove(listing) do
    listing
    |> change()
    |> put_change(:public_approved, false)
    |> put_change(:public_approved_on, nil)
    |> put_change(:public_approved_by, nil)
    |> clear_expiry()
  end

  def initial_expiry(listing) do
    initial_expiry_date =
      VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
      |> Timex.shift(days: @initial_expiry_days)
      |> Timex.to_datetime("UTC")

    change(listing, %{
      public_expiry_date: initial_expiry_date,
      public_expiry_reminder_sent: false
    })
  end

  def clear_expiry(listing) do
    change(listing, %{
      public_expiry_date: nil,
      public_expiry_reminder_sent: false
    })
  end

  # NOTE: This must only change the date, because the app must be able to
  # correctly handle cases where the listing is manually expired, and where
  # the listing automatically expires due to passage of time. Both conditions
  # are treated as one!
  def expire(listing) do
    expiry_date =
      VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
      |> Timex.shift(minutes: -5)
      |> Timex.to_datetime("UTC")

    change(listing, %{
      public_expiry_date: expiry_date
    })
  end

  def refresh(listing) do
    listing = change(listing, %{})

    new_expiry_date =
      VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
      |> Timex.shift(days: @refresh_expiry_days)
      |> Timex.to_datetime("UTC")

    listing
    |> fetch_field!(:public_expiry_date)
    |> case do
      nil ->
        add_error(listing, :public_expiry_date, "cannot refresh, no existing expiry")

      %{__struct__: DateTime} = existing_expiry_date ->
        if VolunteerUtils.Temporal.is?(existing_expiry_date, :newer, new_expiry_date) do
          add_error(listing, :public_expiry_date, "cannot refresh, existing expiry newer", days: @refresh_expiry_days)
        else
          change(listing, %{
            public_expiry_date: new_expiry_date,
            public_expiry_reminder_sent: false
          })
        end
    end
  end

  def expiry_reminder_sent(listing) do
    change(listing, %{
      public_expiry_reminder_sent: true
    })
  end
end
