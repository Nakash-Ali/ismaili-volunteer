require IEx

defmodule VolunteerWeb.LegacyController do
  use VolunteerWeb, :controller

  alias Ecto.Changeset
  alias Volunteer.Legacy
  import VolunteerWeb.ErrorHelpers

  @next "https://ismailivolunteer.netlify.com/thankyou"
  @error "https://ismailivolunteer.netlify.com/error"

  plug :rate_limit
  plug :verify_captcha

  def apply(conn, params) do
    case Legacy.apply(params) do
      {:ok, _, _} -> redirect conn, external: @next
      {:error, error} -> handle_error(conn, error)
    end
  end

  defp rate_limit(%Plug.Conn{remote_ip: remote_ip_tuple} = conn, _) do
    remote_ip_string = remote_ip_tuple
      |> Tuple.to_list
      |> Enum.join(".")
    case Hammer.check_rate("legacy.apply:#{remote_ip_string}", 60 * 1000, 10) do
      {:allow, _} -> conn
      {:deny, _} -> handle_error(conn, %{message: "Rate limit exceeded"})
    end
  end

  defp verify_captcha(%Plug.Conn{params: params} = conn, _) do
    case Recaptcha.verify(params["g-recaptcha-response"]) do
      {:ok, _} -> conn
      {:error, reasons} -> handle_error(conn, %{message: "reCaptcha verification failed", reasons: reasons})
    end
  end

  defp handle_error(%Plug.Conn{} = conn, %Changeset{} = changeset) do
    encoded_errors = changeset
      |> translate_errors
      |> Legacy.translate_to_public_keys(replace_keys: true)
      |> Enum.into(%{})
      |> Poison.encode!
      |> Base.url_encode64
    redirect conn, external: "#{@error}?changeset_errors=#{encoded_errors}"
  end

  defp handle_error(%Plug.Conn{} = conn, errors) do
    encoded_errors = errors
      |> Poison.encode!
      |> Base.url_encode64
    redirect conn, external: "#{@error}?errors=#{encoded_errors}"
  end

  defp translate_errors(changeset) do
    Changeset.traverse_errors(changeset, &translate_error/1)
  end
end
