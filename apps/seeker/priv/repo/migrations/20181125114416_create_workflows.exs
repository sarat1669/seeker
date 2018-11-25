defmodule Seeker.Repo.Migrations.CreateWorkflows do
  use Ecto.Migration

  def change do
    create table(:workflows) do
      add :name, :string
      add :nodes, { :array, :map }
      add :edges, { :array, :map }
      add :params, { :array, :string }

      timestamps()
    end

    create unique_index(:workflows, [:name])
  end
end
