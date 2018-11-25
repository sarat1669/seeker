defmodule Seeker.FlowTest do
  use Seeker.DataCase

  alias Seeker.Flow

  describe "components" do
    alias Seeker.Flow.Components

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def components_fixture(attrs \\ %{}) do
      {:ok, components} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Flow.create_components()

      components
    end

    test "list_components/0 returns all components" do
      components = components_fixture()
      assert Flow.list_components() == [components]
    end

    test "get_components!/1 returns the components with given id" do
      components = components_fixture()
      assert Flow.get_components!(components.id) == components
    end

    test "create_components/1 with valid data creates a components" do
      assert {:ok, %Components{} = components} = Flow.create_components(@valid_attrs)
    end

    test "create_components/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Flow.create_components(@invalid_attrs)
    end

    test "update_components/2 with valid data updates the components" do
      components = components_fixture()
      assert {:ok, components} = Flow.update_components(components, @update_attrs)
      assert %Components{} = components
    end

    test "update_components/2 with invalid data returns error changeset" do
      components = components_fixture()
      assert {:error, %Ecto.Changeset{}} = Flow.update_components(components, @invalid_attrs)
      assert components == Flow.get_components!(components.id)
    end

    test "delete_components/1 deletes the components" do
      components = components_fixture()
      assert {:ok, %Components{}} = Flow.delete_components(components)
      assert_raise Ecto.NoResultsError, fn -> Flow.get_components!(components.id) end
    end

    test "change_components/1 returns a components changeset" do
      components = components_fixture()
      assert %Ecto.Changeset{} = Flow.change_components(components)
    end
  end

  describe "components" do
    alias Seeker.Flow.Components

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def components_fixture(attrs \\ %{}) do
      {:ok, components} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Flow.create_components()

      components
    end

    test "list_components/0 returns all components" do
      components = components_fixture()
      assert Flow.list_components() == [components]
    end

    test "get_components!/1 returns the components with given id" do
      components = components_fixture()
      assert Flow.get_components!(components.id) == components
    end

    test "create_components/1 with valid data creates a components" do
      assert {:ok, %Components{} = components} = Flow.create_components(@valid_attrs)
      assert components.name == "some name"
    end

    test "create_components/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Flow.create_components(@invalid_attrs)
    end

    test "update_components/2 with valid data updates the components" do
      components = components_fixture()
      assert {:ok, components} = Flow.update_components(components, @update_attrs)
      assert %Components{} = components
      assert components.name == "some updated name"
    end

    test "update_components/2 with invalid data returns error changeset" do
      components = components_fixture()
      assert {:error, %Ecto.Changeset{}} = Flow.update_components(components, @invalid_attrs)
      assert components == Flow.get_components!(components.id)
    end

    test "delete_components/1 deletes the components" do
      components = components_fixture()
      assert {:ok, %Components{}} = Flow.delete_components(components)
      assert_raise Ecto.NoResultsError, fn -> Flow.get_components!(components.id) end
    end

    test "change_components/1 returns a components changeset" do
      components = components_fixture()
      assert %Ecto.Changeset{} = Flow.change_components(components)
    end
  end

  describe "components" do
    alias Seeker.Flow.Component

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def component_fixture(attrs \\ %{}) do
      {:ok, component} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Flow.create_component()

      component
    end

    test "list_components/0 returns all components" do
      component = component_fixture()
      assert Flow.list_components() == [component]
    end

    test "get_component!/1 returns the component with given id" do
      component = component_fixture()
      assert Flow.get_component!(component.id) == component
    end

    test "create_component/1 with valid data creates a component" do
      assert {:ok, %Component{} = component} = Flow.create_component(@valid_attrs)
      assert component.name == "some name"
    end

    test "create_component/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Flow.create_component(@invalid_attrs)
    end

    test "update_component/2 with valid data updates the component" do
      component = component_fixture()
      assert {:ok, component} = Flow.update_component(component, @update_attrs)
      assert %Component{} = component
      assert component.name == "some updated name"
    end

    test "update_component/2 with invalid data returns error changeset" do
      component = component_fixture()
      assert {:error, %Ecto.Changeset{}} = Flow.update_component(component, @invalid_attrs)
      assert component == Flow.get_component!(component.id)
    end

    test "delete_component/1 deletes the component" do
      component = component_fixture()
      assert {:ok, %Component{}} = Flow.delete_component(component)
      assert_raise Ecto.NoResultsError, fn -> Flow.get_component!(component.id) end
    end

    test "change_component/1 returns a component changeset" do
      component = component_fixture()
      assert %Ecto.Changeset{} = Flow.change_component(component)
    end
  end

  describe "workflows" do
    alias Seeker.Flow.Workflow

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def workflow_fixture(attrs \\ %{}) do
      {:ok, workflow} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Flow.create_workflow()

      workflow
    end

    test "list_workflows/0 returns all workflows" do
      workflow = workflow_fixture()
      assert Flow.list_workflows() == [workflow]
    end

    test "get_workflow!/1 returns the workflow with given id" do
      workflow = workflow_fixture()
      assert Flow.get_workflow!(workflow.id) == workflow
    end

    test "create_workflow/1 with valid data creates a workflow" do
      assert {:ok, %Workflow{} = workflow} = Flow.create_workflow(@valid_attrs)
      assert workflow.name == "some name"
    end

    test "create_workflow/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Flow.create_workflow(@invalid_attrs)
    end

    test "update_workflow/2 with valid data updates the workflow" do
      workflow = workflow_fixture()
      assert {:ok, workflow} = Flow.update_workflow(workflow, @update_attrs)
      assert %Workflow{} = workflow
      assert workflow.name == "some updated name"
    end

    test "update_workflow/2 with invalid data returns error changeset" do
      workflow = workflow_fixture()
      assert {:error, %Ecto.Changeset{}} = Flow.update_workflow(workflow, @invalid_attrs)
      assert workflow == Flow.get_workflow!(workflow.id)
    end

    test "delete_workflow/1 deletes the workflow" do
      workflow = workflow_fixture()
      assert {:ok, %Workflow{}} = Flow.delete_workflow(workflow)
      assert_raise Ecto.NoResultsError, fn -> Flow.get_workflow!(workflow.id) end
    end

    test "change_workflow/1 returns a workflow changeset" do
      workflow = workflow_fixture()
      assert %Ecto.Changeset{} = Flow.change_workflow(workflow)
    end
  end
end
