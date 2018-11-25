defmodule SeekerWeb do
  @moduledoc false

  def controller do
    quote do
      use Phoenix.Controller, namespace: SeekerWeb, moduledoc: false
      import Plug.Conn
      import SeekerWeb.Router.Helpers
      import SeekerWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/seeker_web/templates",
                        namespace: SeekerWeb, moduledoc: false

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import SeekerWeb.Router.Helpers
      import SeekerWeb.ErrorHelpers
      import SeekerWeb.Gettext
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
      import SeekerWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
