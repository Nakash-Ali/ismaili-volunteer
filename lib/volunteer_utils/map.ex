defmodule VolunteerUtils.Map do
  def list_to_map(list) do
    list
    |> Enum.with_index(0)
    |> Enum.map(fn {value, index} -> {Integer.to_string(index), value} end)
    |> Enum.into(%{})
  end

  def update_all_values(to_update, func) when is_map(to_update) and is_function(func, 1) do
    Enum.map(to_update, fn {key, value} ->
      {key, func.(value)}
    end)
    |> Enum.into(%{})
  end
end
