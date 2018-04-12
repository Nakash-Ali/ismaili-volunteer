defmodule VolunteerEmail do
  def view do
    quote do
      use Phoenix.View,
        root: "lib/volunteer_email/templates",
        namespace: VolunteerEmail

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML
      import Bamboo.Email
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
