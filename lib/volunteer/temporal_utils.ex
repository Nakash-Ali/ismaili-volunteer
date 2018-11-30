defmodule Volunteer.TemporalUtils do
  def utc_now_truncated_to_seconds do
    utc_now() |> DateTime.truncate(:second)
  end

  def utc_now do
    DateTime.utc_now()
  end
end
