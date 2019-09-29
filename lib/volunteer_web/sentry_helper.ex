defmodule VolunteerWeb.SentryHelper do
  def capture_exception(conn, reason) do
    request = Sentry.Plug.build_request_interface_data(conn, [])
    exception = Exception.normalize(:error, reason)

    _ =
      Sentry.capture_exception(
        exception,
        request: request,
        error_type: :error
      )

    :ok
  end
end
