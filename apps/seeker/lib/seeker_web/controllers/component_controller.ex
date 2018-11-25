defmodule SeekerWeb.ComponentController do
  use SeekerWeb, :controller

  alias Seeker.Flow
  alias Seeker.Flow.Component

  action_fallback SeekerWeb.FallbackController

  def index(conn, _params) do
    components = Flow.list_components()
    render(conn, "index.json", components: components)
  end

  def create(conn, %{"component" => component_params}) do
    with {:ok, %Component{} = component} <- Flow.create_component(component_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", component_path(conn, :show, component))
      |> render("show.json", component: component)
    end
  end

  def show(conn, %{"id" => id}) do
    component = Flow.get_component!(id)
    render(conn, "show.json", component: component)
  end

  def update(conn, %{"id" => id, "component" => component_params}) do
    component = Flow.get_component!(id)

    with {:ok, %Component{} = component} <- Flow.update_component(component, component_params) do
      render(conn, "show.json", component: component)
    end
  end

  def delete(conn, %{"id" => id}) do
    component = Flow.get_component!(id)
    with {:ok, %Component{}} <- Flow.delete_component(component) do
      send_resp(conn, :no_content, "")
    end
  end
end
