defmodule Volunteer.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :type, :string, null: false
      add :region_id, references(:region, on_delete: :restrict), null: true
      add :group_id, references(:group, on_delete: :restrict), null: true
      add :user_id, references(:user, on_delete: :restrict), null: false

      timestamps()
    end

    create unique_index(:roles, [:user_id, :group_id, :region_id])
    create index(:roles, [:user_id])
    create index(:roles, [:group_id])
    create index(:roles, [:region_id])
  end
end
