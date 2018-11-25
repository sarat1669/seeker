defmodule Seeker.Repo.Migrations.CreateComponents do
  use Ecto.Migration

  def change do
    create table(:components) do
      add :name, :string
      add :code, :map
      add :inports, { :array, :string }
      add :outports, { :array, :string }

      timestamps()
    end

    create unique_index(:components, [:name])
  end
end
