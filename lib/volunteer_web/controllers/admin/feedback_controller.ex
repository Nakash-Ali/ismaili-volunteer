defmodule VolunteerWeb.Admin.FeedbackController do
  use VolunteerWeb, :controller

  def index(conn, _params) do
    # should_anonymize =
    #   Map.get(params, "anonymize", "false")

    canny_user =
      conn
      |> VolunteerWeb.UserSession.get_user
      # |> get_canny_user_params(should_anonymize)
      |> get_canny_user_params()

    canny_assigns =
      VolunteerWeb.Services.Canny.get_config("admin", canny_user)

    render(conn, "index.html", canny_assigns: canny_assigns)
  end

  # def get_canny_user_params(user, "true"), do: get_canny_user_params(user, true)
  # def get_canny_user_params(user, "false"), do: get_canny_user_params(user, false)

  # def get_canny_user_params(user, true) do
  #   user_id_hash =
  #     :crypto.hash(:sha256, "#{user.id}") |> Base.url_encode64
  #
  #   %{
  #     id: user_id_hash,
  #     name: "Anonymous",
  #     email: user.primary_email
  #   }
  # end

  def get_canny_user_params(user) do
    %{
      id: user.id,
      name: user.title,
      email: user.primary_email,
    }
  end
end
