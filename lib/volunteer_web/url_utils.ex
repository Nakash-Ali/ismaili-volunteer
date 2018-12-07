defmodule VolunteerWeb.URLUtils do
  def put_in_query(url, key, value) do
    url
    |> URI.parse()
    |> Map.update(:query, nil, fn querystring ->
      case querystring do
        nil -> ""
        _ -> querystring
      end
      |> URI.decode_query()
      |> Map.put(key, value)
      |> URI.encode_query()
    end)
    |> URI.to_string()
  end
end
