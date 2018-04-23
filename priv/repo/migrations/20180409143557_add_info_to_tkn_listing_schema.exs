defmodule Volunteer.Repo.Migrations.AddInfoToTKNListingSchema do
  use Ecto.Migration

  def change do
    alter table(:tkn_listings) do
      add :enabled, :boolean, default: false, null: false
    end
    
    drop index(:tkn_listings, [:listing_id])
    create unique_index(:tkn_listings, [:listing_id])
  end
end
