defmodule VolunteerWeb.Presenters.Temporal do
  def format_date(%Date{} = date) do
    date
    |> Timex.format!("{D} {Mfull} {YYYY}")
  end

  def format_datetime(%DateTime{} = datetime) do
    datetime
    |> Timex.Timezone.convert("America/Toronto")
    |> Timex.format!("{WDfull}, {D} {Mfull} {YYYY} at {h24}:{m} ({Zabbr})")
  end

  def format_duration_from_now(%DateTime{} = future_datetime, exclude \\ ["seconds"], if_now \\ "now") do
    VolunteerUtils.Temporal.utc_now_truncated_to_seconds()
    |> Timex.diff(future_datetime, :duration)
    |> Timex.format_duration(:humanized)
    |> String.split(", ")
    |> Enum.reject(&String.contains?(&1, exclude))
    |> Enum.join(", ")
    |> case do
      "" -> if_now
      from_now -> from_now
    end
  end
end
