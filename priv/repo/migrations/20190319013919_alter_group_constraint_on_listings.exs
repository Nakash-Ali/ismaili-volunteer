defmodule Volunteer.Repo.Migrations.AlterGroupConstraintOnListings do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE listings DROP CONSTRAINT listings_group_id_fkey"
    alter table(:listings) do
      modify :group_id, references(:groups, on_delete: :delete_all), null: false
    end
  end
end
