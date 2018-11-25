defmodule Seeker.Flow.Workflow do
  use Ecto.Schema
  import Ecto.Changeset


  schema "workflows" do
    field :name, :string
    field :nodes, { :array, :map }
    field :edges, { :array, :map }
    field :params, { :array, :string }

    timestamps()
  end

  @doc false
  def changeset(workflow, attrs) do
    workflow
    |> cast(attrs, [:name, :nodes, :edges, :params])
    |> validate_required([:name, :nodes, :edges, :params])
    |> unique_constraint(:name)
  end
end
