defmodule VolunteerUtils.Keyword do
  def all_keys_unique?(list) do
    keys = Keyword.keys(list)
    keys == Enum.dedup(keys)
  end
end
