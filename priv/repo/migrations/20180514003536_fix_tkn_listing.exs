defmodule Volunteer.Repo.Migrations.FixTKNListing do
  use Ecto.Migration

  def change do
    drop table(:tkn_listings)
    drop_if_exists index(:tkn_listings, [:listing_id])
    
    create table(:tkn_listings) do
      add :openings, :integer, null: false
      add :commitment_type, :string, null: false
      add :location_type, :string, null: false
      add :search_scope, :string, null: false
      add :suggested_keywords, :string, null: false
      
      add :function, :string, null: false, default: ""
      add :industry, :string, null: false, default: ""
      add :education_level, :string, null: false, default: ""
      add :work_experience_level, :string, null: false, default: ""      

      add :listing_id, references(:listings, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tkn_listings, [:listing_id])
  end
end
