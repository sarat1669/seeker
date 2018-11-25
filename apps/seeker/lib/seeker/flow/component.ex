defmodule Seeker.Flow.Component do
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
