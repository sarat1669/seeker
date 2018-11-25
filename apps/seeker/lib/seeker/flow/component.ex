defmodule Seeker.Flow.Component do
  @moduledoc """
  Component model.

  Each component has a `name`, `code`, `inports` and `outports`

  `name` is a string

  `code` is the DSL defined in `Composer.DSL`

  `inports` is a list of atoms, which will be provided as the binding to the worflow for execution

  `outports` is a list of atoms from the binding which will be used to construct the response object

  #### Sample component

  ```elixir
  {
  	"component": {
  		"name": "adder",
  		"code": {
          	"type": "=", "arguments": [
              	{ "type": "var", "arguments": [ { "type": "atom", "arguments": [ "c" ] } ] },
              	{
             			"type": "+", "arguments": [
                 			{ "type": "var", "arguments": [ { "type": "atom", "arguments": [ "a" ] } ] },
                 			{ "type": "var", "arguments": [ { "type": "atom", "arguments": [ "b" ] } ] }
             			]
             		}
  			]
  		},
  		"inports": [ "a", "b" ],
  		"outports": [ "c" ]
  	}
  }
  ```
  """

  use Ecto.Schema
  import Ecto.Changeset


  schema "components" do
    field :name, :string
    field :code, :map
    field :inports, { :array, :string }
    field :outports, { :array, :string }

    timestamps()
  end

  @doc false
  def changeset(components, attrs) do
    components
    |> cast(attrs, [:name, :code, :inports, :outports])
    |> validate_required([:name, :code, :inports, :outports])
    |> unique_constraint(:name)
  end
end
