defmodule Volunteer.Repo.Migrations.CreateGroups do
  use Ecto.Migration

  def change do
    create table(:groups) do
      add :title, :string
      add :parent_path, {:array, :id}, default: []
      add :parent, references(:groups, on_delete: :restrict), null: true
      add :region, references(:regions, on_delete: :restrict)

      timestamps()
    end

    create index(:groups, [:parent_path])
    create index(:groups, [:parent])
    create index(:groups, [:region])
  end
end
