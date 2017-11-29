defmodule VolunteerWeb.LegacyController do
  use VolunteerWeb, :controller

  alias Ecto.Changeset
  alias Volunteer.Legacy
  import VolunteerWeb.ErrorHelpers

  plug :rate_limit
  # plug :verify_captcha

  # action_fallback :fallback

  def apply(conn, params) do
    {_, changeset} = Legacy.apply(params)
    response_map = Map.take(changeset, [
      :action,
      :changes,
      :data,
      :empty_values,
      :params,
      :valid?,
    ])
    json(conn, Map.merge(response_map, %{errors: translate_errors(changeset)}))
  end

  defp fallback(conn, error) do
    conn
      |> put_status(:not_found)
      |> json(error)
      |> halt
  end

  defp rate_limit(%Plug.Conn{remote_ip: remote_ip_tuple} = conn, _) do
    remote_ip_string = remote_ip_tuple
      |> Tuple.to_list
      |> Enum.join(".")
    case Hammer.check_rate("legacy.apply:#{remote_ip_string}", 60 * 1000, 10) do
      {:allow, _} -> conn
      {:deny, limit} -> fallback(conn, %{error: "rate-limit of #{limit} exceeded"})
    end
  end

  defp verify_captcha(%Plug.Conn{params: params} = conn, _) do
    case Recaptcha.verify(params["g-recaptcha-response"]) do
      {:ok, _} -> conn
      {:error, reasons} -> fallback(conn, %{error: "recaptcha verification failed", reasons: reasons})
    end
  end

  defp translate_errors(changeset) do
    Changeset.traverse_errors(changeset, &translate_error/1)
  end
end
