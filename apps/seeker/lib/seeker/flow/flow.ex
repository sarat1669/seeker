defmodule Seeker.Flow do
  @moduledoc false

  import Ecto.Query, warn: false
  alias Seeker.Repo
  alias Seeker.Executor
  alias Seeker.Flow.Component

  @doc """
  Returns the list of components.

  ## Examples

      iex> list_components()
      [%Component{}, ...]

  """
  def list_components do
    Repo.all(Component)
  end

  @doc """
  Gets a single components.

  Raises `Ecto.NoResultsError` if the Component does not exist.

  ## Examples

      iex> get_components!(123)
      %Component{}

      iex> get_components!(456)
      ** (Ecto.NoResultsError)

  """
  def get_components!(id), do: Repo.get!(Component, id)

  @doc """
  Creates a components.

  ## Examples

      iex> create_components(%{field: value})
      {:ok, %Component{}}

      iex> create_components(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_components(attrs \\ %{}) do
    %Component{}
    |> Component.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a components.

  ## Examples

      iex> update_components(components, %{field: new_value})
      {:ok, %Component{}}

      iex> update_components(components, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_components(%Component{} = components, attrs) do
    components
    |> Component.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Component.

  ## Examples

      iex> delete_components(components)
      {:ok, %Component{}}

      iex> delete_components(components)
      {:error, %Ecto.Changeset{}}

  """
  def delete_components(%Component{} = components) do
    Repo.delete(components)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking components changes.

  ## Examples

      iex> change_components(components)
      %Ecto.Changeset{source: %Component{}}

  """
  def change_components(%Component{} = components) do
    Component.changeset(components, %{})
  end

  alias Seeker.Flow.Component

  @doc """
  Returns the list of components.

  ## Examples

      iex> list_components()
      [%Component{}, ...]

  """
  def list_components do
    Repo.all(Component)
  end

  @doc """
  Gets a single component.

  Raises `Ecto.NoResultsError` if the Component does not exist.

  ## Examples

      iex> get_component!(123)
      %Component{}

      iex> get_component!(456)
      ** (Ecto.NoResultsError)

  """
  def get_component!(id), do: Repo.get!(Component, id)

  @doc """
  Creates a component.

  ## Examples

      iex> create_component(%{field: value})
      {:ok, %Component{}}

      iex> create_component(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_component(attrs \\ %{}) do
    %Component{}
    |> Component.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a component.

  ## Examples

      iex> update_component(component, %{field: new_value})
      {:ok, %Component{}}

      iex> update_component(component, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_component(%Component{} = component, attrs) do
    component
    |> Component.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Component.

  ## Examples

      iex> delete_component(component)
      {:ok, %Component{}}

      iex> delete_component(component)
      {:error, %Ecto.Changeset{}}

  """
  def delete_component(%Component{} = component) do
    Repo.delete(component)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking component changes.

  ## Examples

      iex> change_component(component)
      %Ecto.Changeset{source: %Component{}}

  """
  def change_component(%Component{} = component) do
    Component.changeset(component, %{})
  end

  alias Seeker.Flow.Workflow

  @doc """
  Returns the list of workflows.

  ## Examples

      iex> list_workflows()
      [%Workflow{}, ...]

  """
  def list_workflows do
    Repo.all(Workflow)
  end

  @doc """
  Gets a single workflow.

  Raises `Ecto.NoResultsError` if the Workflow does not exist.

  ## Examples

      iex> get_workflow!(123)
      %Workflow{}

      iex> get_workflow!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workflow!(id), do: Repo.get!(Workflow, id)

  @doc """
  Creates a workflow.

  ## Examples

      iex> create_workflow(%{field: value})
      {:ok, %Workflow{}}

      iex> create_workflow(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workflow(attrs \\ %{}) do
    %Workflow{}
    |> Workflow.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workflow.

  ## Examples

      iex> update_workflow(workflow, %{field: new_value})
      {:ok, %Workflow{}}

      iex> update_workflow(workflow, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workflow(%Workflow{} = workflow, attrs) do
    workflow
    |> Workflow.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Workflow.

  ## Examples

      iex> delete_workflow(workflow)
      {:ok, %Workflow{}}

      iex> delete_workflow(workflow)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workflow(%Workflow{} = workflow) do
    Repo.delete(workflow)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workflow changes.

  ## Examples

      iex> change_workflow(workflow)
      %Ecto.Changeset{source: %Workflow{}}

  """
  def change_workflow(%Workflow{} = workflow) do
    Workflow.changeset(workflow, %{})
  end

  def execute_workflow(conn, params) do
    method = Map.get(conn, :method)
    id = Map.get(params, "id")
    workflow = get_workflow!(id)
    Executor.get_config(workflow, params)
  end
end
