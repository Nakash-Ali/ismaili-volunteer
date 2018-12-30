defmodule VolunteerWeb.Admin.FeedbackController do
  use VolunteerWeb, :controller

  @admin_feedback_anonymize_icc %{
    key: :admin_feedback_anonymize,
    type: :boolean,
    default: false,
  }

  plug VolunteerWeb.InsecureCookieConfigStore, @admin_feedback_anonymize_icc

  def index(conn, _params) do
    %{admin_feedback_anonymize: admin_feedback_anonymize} = conn.assigns.cookie_config

    canny_user =
      VolunteerWeb.Services.Canny.get_user_config(conn, admin_feedback_anonymize)

    canny_assigns =
      VolunteerWeb.Services.Canny.get_config("admin", canny_user)

    render(
      conn,
      "index.html",
      canny_assigns: canny_assigns,
      canny_user: canny_user,
      admin_feedback_anonymize: admin_feedback_anonymize,
    )
  end
end
