defmodule Seeker.Flow.Workflow do
  @moduledoc """
  Workflow model.

  Each workflow has a `name`, `nodes`, `edges` and `params`

  `name` is a string

  `nodes` is a list of nodes

    - A node has an `id`, `type`, `component`

    - `id ` should be unique for each node

    - A node can be of three types: "in", "normal", "out"

    - `component` is the component id in the database

  `edges` is as defined in `LightBridge.Workflow`

  `outports` is a list of atoms from the binding which will be used to construct the response object

  #### Sample workflow

  ```elixir
  {
  	"workflow": {
  		"name": "test",
  		"params": [ "a", "b" ],
  		"nodes": [
  			{ "id": 0, "type": "in", "component": "1" },
  			{ "id": 1, "type": "out", "component": "1" }
  		],
  		"edges": [
  			{ "source_node": 0, "target_node": 1, "source_port": "c", "target_port": "a" },
      		{ "source_node": 0, "target_node": 1, "source_port": "c", "target_port": "b" }
  		]
  	}
  }
  """
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
