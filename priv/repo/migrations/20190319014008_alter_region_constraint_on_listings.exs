defmodule Volunteer.Repo.Migrations.AlterRegionConstraintOnListings do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE listings DROP CONSTRAINT listings_region_id_fkey"
    alter table(:listings) do
      modify :region_id, references(:regions, on_delete: :delete_all), null: false
    end
  end
end
