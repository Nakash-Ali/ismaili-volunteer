defmodule Volunteer.Repo.Migrations.CreateTknListings do
  use Ecto.Migration

  def change do
    create table(:tkn_listings) do
      add :openings, :integer, null: false

      add :position_industry, :string, null: false
      add :position_category, :string, null: false

      timestamps()
    end

  end
end
