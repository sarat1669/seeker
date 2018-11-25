defmodule SeekerWeb.ComponentView do
  use SeekerWeb, :view
  alias SeekerWeb.ComponentView

  def render("index.json", %{components: components}) do
    %{data: render_many(components, ComponentView, "component.json")}
  end

  def render("show.json", %{component: component}) do
    %{data: render_one(component, ComponentView, "component.json")}
  end

  def render("component.json", %{component: component}) do
    %{
      id: component.id,
      name: component.name,
      code: component.code,
      inports: component.inports,
      outports: component.outports,
    }
  end
end
