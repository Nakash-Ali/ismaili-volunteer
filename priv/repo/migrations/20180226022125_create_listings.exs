defmodule Volunteer.Repo.Migrations.CreateListings do
  use Ecto.Migration

  def change do
    create table(:listings) do
      add :expiry_date, :timestamptz, null: false

      add :created_by_id, references(:users, on_delete: :restrict), null: false

      add :approved, :boolean, default: false, null: false
      add :approved_by_id, references(:users, on_delete: :nothing), null: true
      add :approved_on, :timestamptz, null: true

      add :position_title, :string, null: false
      add :program_title, :string, null: true
      add :summary_line, :string, null: false
      add :group_id, references(:groups, on_delete: :restrict), null: false
      add :organized_by_id, references(:users, on_delete: :restrict), null: false

      add :start_date, :date, null: true
      add :end_date, :date, null: true
      add :hours_per_week, :integer, null: false

      add :program_description, :text, null: false
      add :responsibilities, :text, null: false
      add :qualifications, :text, null: false

      add :tkn_eligible, :boolean, default: true, null: false

      timestamps()
    end

    create index(:listings, [:created_by_id])
    create index(:listings, [:approved_by_id])
    create index(:listings, [:group_id])
    create index(:listings, [:organized_by_id])
  end
end
