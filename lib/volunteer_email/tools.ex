defmodule VolunteerEmail.Tools do
  def append(email, key, address) when not is_list(address) do
    append(email, key, [address])
  end

  def append(email, key, address_list) when key in [:to, :cc, :bcc] do
    case Map.fetch!(email, key) do
      nil ->
        Map.put(email, key, address_list)

      existing when is_list(existing) ->
        Map.put(email, key, existing ++ address_list)
    end
  end
end
