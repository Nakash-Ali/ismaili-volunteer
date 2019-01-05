defmodule VolunteerUtils.File do
  def append_extension(filename, ext) do
    "#{filename}.#{ext}"
  end

  def run_func_if_not_exists(disk_path, func) do
    case File.stat(disk_path) do
      {:ok, %File.Stat{type: :regular}} ->
        {:ok, :exists}

      _ ->
        func.()
    end
  end

  def consistent_hash_b64(components) when is_list(components) do
    Enum.join(components, "") |> consistent_hash_b64
  end

  def consistent_hash_b64(components) when is_binary(components) do
    :sha
    |> :crypto.hash(components)
    |> Base.hex_encode32(case: :lower, padding: false)
  end
end
