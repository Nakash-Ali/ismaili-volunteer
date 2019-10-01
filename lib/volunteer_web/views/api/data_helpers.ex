defmodule VolunteerWeb.API.DataHelpers do
  def to_iso8601(nil), do: nil
  def to_iso8601(%Date{} = date), do: Date.to_iso8601(date)
  def to_iso8601(%DateTime{} = datetime), do: DateTime.to_iso8601(datetime)

  def nilify?(""), do: nil
  def nilify?(str) when is_binary(str), do: str
end
