defmodule SeekerWeb.ComponentControllerTest do
  use SeekerWeb.ConnCase

  alias Seeker.Flow
  alias Seeker.Flow.Component

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:component) do
    {:ok, component} = Flow.create_component(@create_attrs)
    component
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all components", %{conn: conn} do
      conn = get conn, component_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create component" do
    test "renders component when data is valid", %{conn: conn} do
      conn = post conn, component_path(conn, :create), component: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, component_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, component_path(conn, :create), component: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update component" do
    setup [:create_component]

    test "renders component when data is valid", %{conn: conn, component: %Component{id: id} = component} do
      conn = put conn, component_path(conn, :update, component), component: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, component_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, component: component} do
      conn = put conn, component_path(conn, :update, component), component: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete component" do
    setup [:create_component]

    test "deletes chosen component", %{conn: conn, component: component} do
      conn = delete conn, component_path(conn, :delete, component)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, component_path(conn, :show, component)
      end
    end
  end

  defp create_component(_) do
    component = fixture(:component)
    {:ok, component: component}
  end
end
