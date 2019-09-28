defmodule VolunteerUtils.Temporal do
  def format_date!(%Date{} = date) do
    Timex.format!(date, "{D} {Mfull} {YYYY}")
  end

  # TODO: replace uses of this with TemporalView.local where appropriate
  def format_datetime!(%DateTime{} = datetime) do
    Timex.format!(datetime, "{WDfull}, {D} {Mfull} {YYYY} at {h24}:{m} ({Zabbr})")
  end

  def format_relative(%DateTime{} = datetime) do
    Timex.from_now(datetime)
  end

  def utc_now_truncated_to_seconds do
    utc_now() |> DateTime.truncate(:second)
  end

  def utc_now do
    DateTime.utc_now()
  end

  def is?(time1, :newer_or_equal, time2) do
    Timex.compare(time1, time2) >= 0
  end

  def is?(time1, :older_or_equal, time2) do
    Timex.compare(time1, time2) <= 0
  end

  def is?(time1, :newer, time2) do
    Timex.compare(time1, time2) > 0
  end

  def is?(time1, :older, time2) do
    Timex.compare(time1, time2) < 0
  end

  def is?(time1, :equal, time2) do
    Timex.compare(time1, time2) == 0
  end
end
