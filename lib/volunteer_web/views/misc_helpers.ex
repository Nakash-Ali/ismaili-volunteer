defmodule VolunteerWeb.MiscHelpers do
  def encode_for_client(nil) do
    encode_for_client(%{})
  end

  def encode_for_client(data) do
    data
    |> Enum.into(%{})
    |> Poison.encode!()
    |> Base.encode64()
    |> Phoenix.HTML.raw()
  end
end
