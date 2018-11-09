defmodule VolunteerWeb.NoRouteErrorController do
  use Phoenix.Controller, namespace: VolunteerWeb

  def raise_error(conn, _params) do
    raise Phoenix.Router.NoRouteError, conn: conn, router: VolunteerWeb.Router
  end
end
