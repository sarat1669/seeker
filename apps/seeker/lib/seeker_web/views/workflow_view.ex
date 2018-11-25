defmodule SeekerWeb.WorkflowView do
  @moduledoc false

  use SeekerWeb, :view
  alias SeekerWeb.WorkflowView

  def render("index.json", %{workflows: workflows}) do
    %{data: render_many(workflows, WorkflowView, "workflow.json")}
  end

  def render("show.json", %{workflow: workflow}) do
    %{data: render_one(workflow, WorkflowView, "workflow.json")}
  end

  def render("workflow.json", %{workflow: workflow}) do
    %{
      id: workflow.id,
      name: workflow.name,
      nodes: workflow.nodes,
      edges: workflow.edges,
      params: workflow.params,
    }
  end

  def render("output.json", %{response: response}) do
    response
  end
end
