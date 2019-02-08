defmodule VolunteerWeb.NoRouteErrorController do
  use Phoenix.Controller, namespace: VolunteerWeb

  def raise_error(conn) do
    raise Phoenix.Router.NoRouteError, conn: conn, router: VolunteerWeb.Router
  end
end
