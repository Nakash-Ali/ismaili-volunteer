defmodule Volunteer.Repo.Migrations.CreateRegions do
  use Ecto.Migration

  def change do
    create table(:regions) do
      add :title, :string
      add :parent_path, {:array, :id}, default: []
      add :parent, references(:regions, on_delete: :restrict), null: true

      timestamps()
    end

    create index(:regions, [:parent])
    create index(:regions, [:parent_path])
  end
end
