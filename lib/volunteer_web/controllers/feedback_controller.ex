defmodule VolunteerWeb.FeedbackController do
  use VolunteerWeb, :controller
  alias VolunteerWeb.ControllerUtils
  alias VolunteerWeb.SessionIdentifier
  alias VolunteerWeb.UserSession

  def index(conn, params) do
    canny_user =
      VolunteerWeb.Services.Canny.get_user_config(conn, false)

    canny_assigns =
      VolunteerWeb.Services.Canny.get_config("public", canny_user)

    render(conn, "index.html", canny_assigns: canny_assigns, canny_user: canny_user)
  end
end
