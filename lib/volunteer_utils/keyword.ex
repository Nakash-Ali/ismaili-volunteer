defmodule VolunteerUtils.Keyword do
  def all_keys_unique?(list) do
    keys = Keyword.keys(list)
    keys == Enum.dedup(keys)
  end

  def raise_if_present!(opts, keys) when is_list(keys) do
    Enum.each(keys, &raise_if_present!(opts, &1))
  end

  def raise_if_present!(opts, key) when is_atom(key) do
    if Keyword.has_key?(opts, key) do
      raise "#{key} cannot be present"
    end
  end
end
