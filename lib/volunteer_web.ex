defmodule VolunteerWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use VolunteerWeb, :controller
      use VolunteerWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: VolunteerWeb
      import Plug.Conn
      import VolunteerWeb.Router.Helpers
      import VolunteerWeb.Gettext
      alias VolunteerWeb.Session

      action_fallback VolunteerWeb.FallbackController
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/volunteer_web/templates",
        pattern: "*",
        namespace: VolunteerWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import VolunteerWeb.Router.Helpers
      import VolunteerWeb.StaticHelpers
      import VolunteerWeb.ErrorHelpers
      import VolunteerWeb.Gettext
      import VolunteerWeb.MiscHelpers
      alias VolunteerWeb.Session
      alias VolunteerWeb.ConnPermissions

      def render(view_module, view_template, assigns, opts) do
        render(view_module, view_template, Enum.concat(assigns, opts))
      end

      def render(view_module, view_template, assigns, keywords, opts) do
        render(view_module, view_template, assigns, Enum.concat(keywords, opts))
      end
    end
  end

  def router do
    quote do
      use Phoenix.Router
      use Plug.ErrorHandler
      use Sentry.Plug
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import VolunteerWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
