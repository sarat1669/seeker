defmodule SeekerWeb.WorkflowController do
  use SeekerWeb, :controller

  alias Seeker.Flow
  alias Seeker.Flow.Workflow

  action_fallback SeekerWeb.FallbackController

  def index(conn, _params) do
    workflows = Flow.list_workflows()
    render(conn, "index.json", workflows: workflows)
  end

  def create(conn, %{"workflow" => workflow_params}) do
    with {:ok, %Workflow{} = workflow} <- Flow.create_workflow(workflow_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", workflow_path(conn, :show, workflow))
      |> render("show.json", workflow: workflow)
    end
  end

  def show(conn, %{"id" => id}) do
    workflow = Flow.get_workflow!(id)
    render(conn, "show.json", workflow: workflow)
  end

  def update(conn, %{"id" => id, "workflow" => workflow_params}) do
    workflow = Flow.get_workflow!(id)

    with {:ok, %Workflow{} = workflow} <- Flow.update_workflow(workflow, workflow_params) do
      render(conn, "show.json", workflow: workflow)
    end
  end

  def delete(conn, %{"id" => id}) do
    workflow = Flow.get_workflow!(id)
    with {:ok, %Workflow{}} <- Flow.delete_workflow(workflow) do
      send_resp(conn, :no_content, "")
    end
  end

  def execute(conn, params) do
    with {:ok, response} <- Flow.execute_workflow(conn, params) do
      render(conn, "output.json", response: response)
    end
  end
end
