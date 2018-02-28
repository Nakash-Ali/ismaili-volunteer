defmodule Utils do

  def keys_to_atoms(mapping) when is_map(mapping) do
    for {key, val} <- mapping, into: %{} do
      {String.to_atom(key), keys_to_atoms(val)}
    end
  end

  def keys_to_atoms(value) do
    value
  end
end
