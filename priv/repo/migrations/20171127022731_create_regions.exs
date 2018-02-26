defmodule Volunteer.Repo.Migrations.CreateRegions do
  use Ecto.Migration

  def change do
    create table(:regions) do
      add :title, :string, null: false
      add :parent_path, {:array, :id}, default: [], null: false

      add :parent_id, references(:regions, on_delete: :restrict), null: true

      timestamps()
    end

    create index(:regions, [:parent_path])
    create index(:regions, [:parent_id])
  end
end
