defmodule Volunteer.Funcs do
  @default_attempts 2

  @config Application.fetch_env!(:volunteer, __MODULE__)

  @url Keyword.fetch!(@config, :url)
  @basic_auth_name Keyword.fetch!(@config, :basic_auth_name)
  @basic_auth_pass Keyword.fetch!(@config, :basic_auth_pass)

  def action!(action, params) when is_binary(action) and is_map(params) do
    params
    |> Map.merge(%{action: action})
    |> run!
  end

  defp run!(request_body) do
    run!(request_body, @default_attempts)
  end

  defp run!(request_body, attempts) when is_map(request_body) and attempts > 0 do
    response = %{headers: headers} = post!(request_body)
    content_type = get_content_type!(headers)

    case {response, content_type} do
      {%{status_code: 200, body: response_body}, {"application", "json", _}} ->
        {:ok, Jason.decode!(response_body)}

      {%{status_code: 400, body: response_body}, {"application", "json", _}} ->
        {:error, Jason.decode!(response_body)}

      {%{status_code: 401} = response, _content_type} ->
        IO.inspect(response)
        raise "Invalid auth for Volunteer.Funcs"

      {%{status_code: status_code} = response, _content_type} ->
        if trunc(status_code / 100) == 5 && attempts > 1 do
          run!(request_body, attempts - 1)
        else
          IO.inspect(response)
          raise "Unexpected response for Volunteer.Funcs"
        end
    end
  end

  defp post!(request_body) do
    HTTPoison.post!(
      @url,
      Jason.encode!(request_body),
      [{"content-type", "application/json"}],
      [recv_timeout: 30_000, hackney: [basic_auth: {@basic_auth_name, @basic_auth_pass}]]
    )
  end

  defp get_content_type!(headers) do
    headers
    |> :hackney_headers.new
    |> (&(
      case :hackney_headers.get_value("content-type", &1, :error) do
        :error ->
          raise "Invalid response returned for Volunteer.Funcs"

        content_type ->
          content_type
      end
    )).()
    |> :hackney_headers.content_type
  end
end
