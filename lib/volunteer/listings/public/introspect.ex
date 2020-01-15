defmodule Volunteer.Listings.Public.Introspect do
  def approved?(%{public_approved: approved}) do
    approved == true
  end

  def unapproved?(%{public_approved: approved}) do
    approved == false
  end

  def has_expiry?(%{public_expiry_date: expiry_date}) do
    expiry_date != nil
  end

  def expired?(%{public_expiry_date: expiry_date}) when not is_nil(expiry_date) do
    Timex.compare(VolunteerUtils.Temporal.utc_now_truncated_to_seconds(), expiry_date) == 1
  end

  def expiry_reminder_sent?(%{public_expiry_reminder_sent: expiry_reminder_sent}) do
    expiry_reminder_sent
  end

  def public?(listing) do
    approved?(listing) and not expired?(listing)
  end

  def previewable?(listing) do
    not approved?(listing)
  end
end
