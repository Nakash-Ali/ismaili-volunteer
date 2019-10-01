defmodule VolunteerWeb.Presenters.JSON do
  def encode_for_client(nil) do
    encode_for_client(%{})
  end

  def encode_for_client(data) do
    data
    |> Enum.into(%{})
    |> Jason.encode!()
    |> Base.encode64()
    |> Phoenix.HTML.raw()
  end

  def nilify?(""), do: nil
  def nilify?(str) when is_binary(str), do: str
end
