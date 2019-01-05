defmodule VolunteerWeb.Admin.FeedbackController do
  use VolunteerWeb, :controller

  def index(conn, params) do
    should_anonymize =
      params
      |> Map.get("anonymize", "false")
      |> VolunteerUtils.Controller.booleanize

    canny_user =
      VolunteerWeb.Services.Canny.get_user_config(conn, should_anonymize)

    canny_assigns =
      VolunteerWeb.Services.Canny.get_config("admin", canny_user)

    render(conn, "index.html", canny_assigns: canny_assigns, canny_user: canny_user, should_anonymize: should_anonymize)
  end
end
