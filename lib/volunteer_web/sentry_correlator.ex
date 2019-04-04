defmodule VolunteerWeb.SentryCorrelator do
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(request_id, event_id) do
    Agent.update(__MODULE__, fn state ->
      Map.put(state, request_id, event_id)
    end)
  end

  def pop(request_id) do
    Agent.get_and_update(__MODULE__, fn state ->
      Map.pop(state, request_id)
    end)
  end

  def set_request_id(conn) do
    [request_id] = Plug.Conn.get_resp_header(conn, "x-request-id")
    Sentry.Context.set_tags_context(%{request_id: request_id})
  end

  def get_event_id(conn) do
    [request_id] = Plug.Conn.get_resp_header(conn, "x-request-id")
    pop(request_id)
  end

  def after_send(event, _result) do
    request_id =
      event
      |> Map.get(:tags, %{})
      |> Map.get(:request_id, nil)

    event_id =
      event
      |> Map.get(:event_id, nil)

    if is_binary(request_id) and is_binary(event_id) do
      save(request_id, event_id)
    else
      :ok
    end
  end
end
