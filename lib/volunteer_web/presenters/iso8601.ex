defmodule VolunteerWeb.Presenters.ISO8601 do
  def stringify(nil), do: nil
  def stringify(%Date{} = date), do: Date.to_iso8601(date)
  def stringify(%DateTime{} = datetime), do: DateTime.to_iso8601(datetime)
end
