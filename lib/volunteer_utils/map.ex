defmodule VolunteerUtils.Map do
  def list_to_map(list) do
    list
    |> Enum.with_index(0)
    |> Enum.map(fn {value, index} -> {Integer.to_string(index), value} end)
    |> Enum.into(%{})
  end

  def keys_to_existing_atoms!(map) do
    map
    |> Enum.map(fn {key, value} -> {String.to_existing_atom(key), value} end)
    |> Enum.into(%{})
  end

  def fetch_in(value, []) do
    {:ok, value}
  end

  def fetch_in(map, [key | tail]) when is_map(map) do
    case Map.fetch(map, key) do
      {:ok, value} ->
        fetch_in(value, tail)

      :error ->
        :error
    end
  end

  def update_always(map, key, default_value, updater_func) do
    new_value =
      if Map.has_key?(map, key) do
        Map.fetch!(map, key)
      else
        default_value
      end
      |> updater_func.()

    Map.put(map, key, new_value)
  end
end
