defmodule Volunteer.Listings.Public.Filters do
  import Ecto.Query

  def approved(query) do
    from(l in query, where: l.public_approved == true)
  end

  def non_public(query) do
    from(l in query, where: l.public_approved == false)
  end

  def expired(query) do
    current_time = VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
    from(l in query, where: l.public_expiry_date < ^current_time)
  end

  def unexpired(query) do
    current_time = VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
    from(l in query, where: l.public_expiry_date >= ^current_time)
  end

  def non_public_or_approved_unexpired(query) do
    current_time = VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
    from(l in query, where: l.public_approved == false or l.public_expiry_date >= ^current_time)
  end

  def non_public_or_expired(query) do
    current_time = VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
    from(l in query,
      where: l.public_approved == false
          or l.public_expiry_date < ^current_time)
  end

  def expiring_before(query, expiry_date) do
    from(l in query, where: l.public_expiry_date <= ^expiry_date)
  end

  def expiry_reminder_not_sent(query) do
    from(l in query, where: l.public_expiry_reminder_sent == false)
  end
end
