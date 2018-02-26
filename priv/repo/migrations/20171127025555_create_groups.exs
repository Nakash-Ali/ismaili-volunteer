defmodule Volunteer.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :title, :string, null: false
      add :region_id, references(:regions, on_delete: :restrict), null: false
      add :parent_path, {:array, :id}, default: [], null: false

      add :parent_id, references(:groups, on_delete: :restrict), null: true

      timestamps()
    end

    create index(:groups, [:region_id])
    create index(:groups, [:parent_path])
    create index(:groups, [:parent_id])
  end
end
