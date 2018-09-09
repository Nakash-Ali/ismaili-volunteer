defmodule VolunteerWeb.Admin.FeedbackController do
  use VolunteerWeb, :controller

  def index(conn, params) do
    should_anonymize =
      params
      |> Map.get("anonymize", "false")
      |> booleanize

    canny_user =
      conn
      |> VolunteerWeb.UserSession.get_user
      |> get_canny_user_params(should_anonymize)

    canny_assigns =
      VolunteerWeb.Services.Canny.get_config("admin", canny_user)

    render(conn, "index.html", canny_assigns: canny_assigns, canny_user: canny_user, should_anonymize: should_anonymize)
  end

  defp booleanize("true"), do: true
  defp booleanize(_value), do: false

  defp get_canny_user_params(user, true) do
    user_id_hash =
      :crypto.hash(:sha256, "#{user.id}") |> Base.url_encode64()

    %{
      id: user_id_hash,
      name: "Anonymous",
      email: "#{user_id_hash}@iicanada.net"
    }
  end

  defp get_canny_user_params(user, false) do
    %{
      id: user.id,
      name: user.title,
      email: user.primary_email,
    }
  end
end
