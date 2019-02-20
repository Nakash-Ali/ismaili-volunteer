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

  def relative(%DateTime{} = datetime) do
    datetime
    |> Timex.from_now("America/Toronto")
  end
end
