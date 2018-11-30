defmodule VolunteerWeb.Legacy.ApplyController do
  use VolunteerWeb, :controller

  alias Ecto.Changeset
  alias Volunteer.Legacy
  import VolunteerWeb.ErrorHelpers

  @env Application.fetch_env!(:volunteer, Volunteer.Legacy)
  @static_site Keyword.fetch!(@env, :static_site)
  @next @static_site <> Keyword.fetch!(@env, :redirect_next_path)
  @error @static_site <> Keyword.fetch!(@env, :redirect_error_path)

  def thank_you(conn, _params) do
    render(conn, "thank_you.html")
  end

  def error(conn, _params) do
    render(conn, "error.html")
  end

  plug :botnectar_protection when action in [:apply]
  plug :rate_limit when action in [:apply]
  plug :verify_captcha when action in [:apply]

  def apply(conn, params) do
    case Legacy.apply(params) do
      {:ok, _, _} -> conn |> redirect(external: @next) |> halt
      {:error, error} -> handle_error(conn, error)
    end
  end

  defp botnectar_protection(%Plug.Conn{} = conn, _) do
    case conn do
      %{params: %{"botnectar" => ""}} -> conn
      %{params: %{"botnectar" => nil}} -> conn
      %{params: %{"botnectar" => _}} -> handle_error(conn)
      _ -> conn
    end
  end

  defp rate_limit(%Plug.Conn{remote_ip: remote_ip_tuple} = conn, _) do
    remote_ip_string =
      remote_ip_tuple
      |> Tuple.to_list()
      |> Enum.join(".")

    # (5 minutes, 10 requests)
    case Hammer.check_rate("legacy.apply:#{remote_ip_string}", 5 * 60 * 1000, 10) do
      {:allow, _} ->
        conn

      {:deny, _} ->
        handle_error(conn, %{
          component: "Rate Limiter",
          message: "Rate limit exceeded. Please wait 5 minutes before trying again!"
        })
    end
  end

  defp verify_captcha(%Plug.Conn{params: params} = conn, _) do
    case Recaptcha.verify(params["g-recaptcha-response"]) do
      {:ok, _} ->
        conn

      {:error, reasons} ->
        handle_error(conn, %{
          component: "reCaptcha",
          message: "reCaptcha verification failed",
          reasons: reasons
        })
    end
  end

  defp handle_error(%Plug.Conn{} = conn, %Changeset{} = changeset) do
    all_errors = translate_errors(changeset)

    error_defs = [
      {:public, "public_errors"},
      {:system, "system_errors"}
    ]

    query_string =
      error_defs
      |> Enum.map(fn {atom, map_key} ->
        case Legacy.translate_keys(atom, all_errors, replace_keys: true) do
          [] -> nil
          errors -> {map_key, errors |> Enum.into(%{}) |> encode_errors}
        end
      end)
      |> Enum.filter(& &1)
      |> URI.encode_query()

    conn |> redirect(external: "#{@error}?#{query_string}") |> halt
  end

  defp handle_error(%Plug.Conn{} = conn, errors) when is_map(errors) do
    conn |> redirect(external: "#{@error}?errors=#{encode_errors(errors)}") |> halt
  end

  defp handle_error(%Plug.Conn{} = conn) do
    conn |> redirect(external: "#{@error}") |> halt
  end

  defp encode_errors(errors) when is_map(errors) do
    errors |> Jason.encode!() |> Base.url_encode64()
  end

  defp encode_errors(_) do
    nil
  end

  defp translate_errors(changeset) do
    Changeset.traverse_errors(changeset, &translate_error/1)
  end
end
