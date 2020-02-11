defmodule Volunteer.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :actor_id, references(:users, on_delete: :restrict), null: false
      add :action, {:array, :string}, null: false
      add :context, :map, default: %{}, null: false
      add :occured_at, :timestamptz, null: false

      add :region_id, references(:regions, on_delete: :delete_all), null: true
      add :group_id, references(:groups, on_delete: :delete_all), null: true
      add :listing_id, references(:listings, on_delete: :delete_all), null: true
      add :applicant_id, references(:applicants, on_delete: :delete_all), null: true

      timestamps()
    end
  end
end
