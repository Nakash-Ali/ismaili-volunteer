defmodule Volunteer.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :type, :string, null: false
      add :region_id, references(:regions, on_delete: :delete_all), null: true
      add :group_id, references(:groups, on_delete: :delete_all), null: true
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:roles, [:user_id, :group_id, :region_id])
    create index(:roles, [:user_id])
    create index(:roles, [:group_id])
    create index(:roles, [:region_id])
  end
end
