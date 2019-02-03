defmodule VolunteerWeb.Admin.UserView do
  use VolunteerWeb, :view
  alias VolunteerWeb.AdminView
  alias VolunteerWeb.Presenters.{Title, Temporal}

  def render("head_extra" <> _, %{conn: conn}) do
    [
      StaticHelpers.stylesheet_tag(conn, "/css/admin/common.css")
    ]
  end

  defp email_list(users) do
    users
    |> Enum.map(fn user -> user.primary_email end)
    |> Enum.join(", ")
  end
end
