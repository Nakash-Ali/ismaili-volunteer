defmodule Volunteer.Funcs do
  @config Application.fetch_env!(:volunteer, __MODULE__)

  @url Keyword.fetch!(@config, :url)
  @basic_auth_name Keyword.fetch!(@config, :basic_auth_name)
  @basic_auth_pass Keyword.fetch!(@config, :basic_auth_pass)

  def run!(action, params) do
    body =
      params
      |> Map.merge(%{action: action})
      |> Jason.encode!

    HTTPoison.post!(
      @url,
      body,
      [{"Content-type", "application/json"}],
      [recv_timeout: 30_000, follow_redirect: true, hackney: [basic_auth: {@basic_auth_name, @basic_auth_pass}]]
    )
    |> case do
      %{status_code: 200, headers: headers, body: body} ->
        headers
        |> fetch_header!("Content-Type")
        |> case do
          "application/json" ->
            {:ok, Jason.decode!(body)}

          "application/pdf" ->
            {:ok, body}

          "image/png" ->
            {:ok, body}
        end

      %{status_code: 400, body: body} ->
        {:error, Jason.decode!(body)}

      %{status_code: 401} = response ->
        IO.inspect(response)
        raise "Invalid auth for Volunteer.Funcs"

      response ->
        IO.inspect(response)
        raise "Unexpected response for Volunteer.Funcs"
    end
  end

  def fetch_header!([], _key), do: raise "Invalid header for Volunteer.Funcs"
  def fetch_header!([{key, value} | _tail], key), do: value
  def fetch_header!([_ | tail], key), do: fetch_header!(tail, key)
end
