defmodule Volunteer.Repo.Migrations.AddRegionToListings do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      add :region_id, references(:regions, on_delete: :restrict), null: false
    end

    create index(:listings, [:region_id])
  end
end
