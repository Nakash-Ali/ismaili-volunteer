defmodule VolunteerWeb.Services.Analytics do
  require Logger

  @url "https://www.google-analytics.com/collect"

  def track_event(resource, action, label, conn) do
    %{
      "v" => 1,
      "t" => "event",
      "ec" => to_string(resource),
      "el" => to_string(label),
      "ea" => to_string(action),
    }
    |> post_async?(conn)
  end

  def global_params() do
    %{
      "tid" => "UA-110560509-1"
    }
  end

  def extract_conn_params(nil) do
    %{}
  end

  def extract_conn_params(_conn) do
    # %{
    #   "cid" => "XXXXXXXXXXXXXXXXXXXXXX"
    # }
    %{}
  end

  def headers() do
    %{
      "Content-Type" => "application/x-www-form-urlencoded"
    }
  end

  def post_async?(params, conn) do
    if Application.get_env(:volunteer, :send_analytics) do
      Task.start(__MODULE__, :post, [params, conn])
    else
      Logger.debug "Analytics request for #{inspect(params)}, ignoring"
    end
  end

  def post(params, conn) do
    all_params =
      conn
      |> extract_conn_params
      |> Map.merge(params)
      |> Map.merge(global_params())
    @url
    |> HTTPoison.post(URI.encode_query(all_params), headers())
    |> case do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        Logger.info "Analytics recorded successfully for #{inspect(all_params)}"
      {:ok, error} ->
        Logger.error "Analytics request failed with #{inspect(error)}"
      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error "Analytics request failed with #{inspect(reason)}"
    end
  end
end
