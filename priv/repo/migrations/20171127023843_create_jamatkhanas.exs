defmodule Volunteer.Repo.Migrations.CreateJamatkhanas do
  use Ecto.Migration

  def change do
    create table(:jamatkhanas) do
      add :title, :string, null: false
      add :region_id, references(:regions, on_delete: :restrict), null: false
      add :address_id, references(:addresses, on_delete: :restrict), null: false

      timestamps()
    end

    create index(:jamatkhanas, [:region_id])
    create index(:jamatkhanas, [:address_id])
  end
end
