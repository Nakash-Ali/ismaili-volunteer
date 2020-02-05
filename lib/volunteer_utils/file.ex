defmodule VolunteerUtils.File do
  def consistent_hash_b64(hash_components) when is_list(hash_components) do
    Enum.join(hash_components, "") |> consistent_hash_b64
  end

  def consistent_hash_b64(hash_components) when is_binary(hash_components) do
    :sha
    |> :crypto.hash(hash_components)
    |> Base.hex_encode32(case: :lower, padding: false)
  end
end
