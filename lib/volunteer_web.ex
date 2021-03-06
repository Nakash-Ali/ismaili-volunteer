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
      import VolunteerWeb.Gettext
      alias VolunteerWeb.Router.Helpers, as: RouterHelpers

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
      import VolunteerWeb.Gettext

      alias VolunteerWeb.Router.Helpers, as: RouterHelpers
      alias VolunteerWeb.StaticHelpers
      alias VolunteerWeb.ErrorHelpers
      alias VolunteerWeb.HTMLHelpers
      alias VolunteerWeb.UserSession
      alias VolunteerWeb.ConnPermissions

      def render(view_module, view_template, assigns, opts) do
        render(view_module, view_template, Enum.concat(assigns, opts))
      end

      def render(view_module, view_template, assigns, keywords, opts) do
        render(view_module, view_template, assigns, Enum.concat(keywords, opts))
      end

      def render_nested([], _opts) do
        nil
      end

      def render_nested([current], opts) do
        render_mixed(current, opts)
      end

      def render_nested([current | remaining], opts) do
        render_nested(remaining, opts ++ [do: render_mixed(current, opts)])
      end

      def render_mixed({view_module, view_template}, opts) do
        render(view_module, view_template, opts)
      end

      def render_mixed(view_template, opts) do
        render(view_template, opts)
      end
    end
  end

  def router do
    quote do
      use Phoenix.Router
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
