defmodule Volunteer.Repo.Migrations.ApprovedByCascade do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE listings DROP CONSTRAINT listings_approved_by_id_fkey"
    alter table(:listings) do
      modify :approved_by_id, references(:users, on_delete: :restrict), null: true
    end
  end
end
