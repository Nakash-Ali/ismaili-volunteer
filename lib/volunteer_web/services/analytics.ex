defmodule VolunteerWeb.Services.Analytics do
  require Logger

  defmodule Plugs do
    # TODO: make sure this is being used everywhere
    # TODO: track when non-html files are being sent
    def track(conn, opts) do
      Plug.Conn.register_before_send(conn, fn conn ->
        resource =
          Keyword.fetch!(opts, :resource)

        action =
          conn
          |> Phoenix.Controller.controller_module()
          |> Macro.underscore()
          |> String.trim_leading("volunteer_web/")
          |> Kernel.<>(":")
          |> Kernel.<>(
            conn
            |> Phoenix.Controller.action_name()
            |> Atom.to_string()
          )

        # TODO: use flash to figure out if an action wqs successfully complete
        # result =
        #   VolunteerWeb.FlashHelpers.parse_for_analytics(conn)

        label =
          Keyword.fetch(opts, :assigns_subject_key)
          |> case do
            {:ok, key} ->
              Map.get(conn.assigns, key, nil)

            :error ->
              Keyword.get(opts, :subject, nil)
          end
          |> case do
            %{id: _id} = subject ->
              VolunteerWeb.Presenters.Slugify.slugify(subject)

            nil ->
              ""
          end

        VolunteerWeb.Services.Analytics.track_event(resource, action, label, conn)

        conn
      end)
    end
  end

  defmodule Params do
    def finalize(given_params, conn) do
      conn
      |> extract_conn_params
      |> Map.merge(given_params)
      |> Map.merge(global_params())
    end

    def global_params() do
      %{
        "tid" => "UA-110560509-1"
      }
    end

    def extract_conn_params(nil) do
      %{}
    end

    def extract_conn_params(conn) do
      %{
        "cid" => VolunteerWeb.SessionIdentifier.get_id(conn)
      }
    end
  end

  defmodule API do
    @url "https://www.google-analytics.com/collect"

    def post_async?(params) do
      if Application.get_env(:volunteer, :send_analytics) do
        Task.start(__MODULE__, :post, [params])
      else
        Logger.debug("Ignoring analytics request for #{inspect(params)}")
      end
    end

    def post(params) do
      @url
      |> HTTPoison.post(URI.encode_query(params), headers())
      |> case do
        {:ok, %HTTPoison.Response{status_code: 200}} ->
          Logger.info("Analytics recorded successfully for #{inspect(params)}")

        {:ok, error} ->
          Logger.error("Analytics request failed with #{inspect(error)}")

        {:error, %HTTPoison.Error{reason: reason}} ->
          Logger.error("Analytics request failed with #{inspect(reason)}")
      end
    end

    def headers() do
      %{
        "Content-Type" => "application/x-www-form-urlencoded"
      }
    end
  end

  def track_event(resource, action, label, conn) do
    %{
      "v" => 1,
      "t" => "event",
      "ec" => to_string(resource),
      "el" => to_string(label),
      "ea" => to_string(action)
    }
    |> Params.finalize(conn)
    |> API.post_async?()
  end
end
