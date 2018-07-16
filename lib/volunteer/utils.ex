defmodule Volunteer.Utils do
  def list_to_map(list) do
    list
    |> Enum.with_index(0)
    |> Enum.map(fn {value, index} -> {Integer.to_string(index), value} end)
    |> Enum.into(%{})
  end
end
