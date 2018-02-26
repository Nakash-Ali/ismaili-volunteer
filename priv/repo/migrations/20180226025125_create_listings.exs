defmodule Volunteer.Repo.Migrations.CreateListings do
  use Ecto.Migration

  def change do
    create table(:listings) do
      add :expiry_date, :date, null: false

      add :approved, :boolean, default: false, null: false
      add :approved_by_id, references(:users, on_delete: :nothing), null: true
      add :approved_on, :utc_datetime, null: true

      add :title, :string, null: false
      add :program_title, :string, null: false
      add :summary_line, :string, null: false
      add :group_id, references(:groups, on_delete: :restrict), null: false
      add :organizing_user_id, references(:users, on_delete: :nothing), null: false

      add :start_date, :date, null: true
      add :end_date, :date, null: true
      add :hours_per_week, :decimal, null: false
      add :commitments, :string, null: true

      add :program_description, :string, null: false
      add :responsibilities, :string, null: false
      add :qualifications, :string, null: false
      add :pro_qualifications, :boolean, default: false, null: false

      add :tkn_eligible, :boolean, default: true, null: false
      add :tkn_listing_id, references(:tkn_listings, on_delete: :delete_all), null: true

      timestamps()
    end

    create index(:listings, [:approved_by_id])
    create index(:listings, [:group_id])
    create index(:listings, [:organizing_user_id])
  end
end
