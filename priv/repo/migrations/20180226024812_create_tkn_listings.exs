defmodule Volunteer.Repo.Migrations.CreateTknListings do
  use Ecto.Migration

  def change do
    create table(:tkn_listings) do
      add :openings, :integer, null: false
      add :position_industry, :string, null: false
      add :position_category, :string, null: false

      add :listing_id, references(:listings, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:tkn_listings, [:listing_id])
  end
end
