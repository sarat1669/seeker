defmodule SeekerWeb.WorkflowControllerTest do
  use SeekerWeb.ConnCase

  alias Seeker.Flow
  alias Seeker.Flow.Workflow

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:workflow) do
    {:ok, workflow} = Flow.create_workflow(@create_attrs)
    workflow
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workflows", %{conn: conn} do
      conn = get conn, workflow_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create workflow" do
    test "renders workflow when data is valid", %{conn: conn} do
      conn = post conn, workflow_path(conn, :create), workflow: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, workflow_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, workflow_path(conn, :create), workflow: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workflow" do
    setup [:create_workflow]

    test "renders workflow when data is valid", %{conn: conn, workflow: %Workflow{id: id} = workflow} do
      conn = put conn, workflow_path(conn, :update, workflow), workflow: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, workflow_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, workflow: workflow} do
      conn = put conn, workflow_path(conn, :update, workflow), workflow: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workflow" do
    setup [:create_workflow]

    test "deletes chosen workflow", %{conn: conn, workflow: workflow} do
      conn = delete conn, workflow_path(conn, :delete, workflow)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, workflow_path(conn, :show, workflow)
      end
    end
  end

  defp create_workflow(_) do
    workflow = fixture(:workflow)
    {:ok, workflow: workflow}
  end
end
