defmodule Volunteer.Repo.Migrations.CreateApplications do
  use Ecto.Migration

  def change do
    create table(:applications) do
      add :listing_id, references(:listings, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      add :preferred_contact, :string, null: false
      add :confirm_availability, :boolean, default: false, null: false

      add :additional_info, :string, null: true
      add :hear_about, :string, null: true

      timestamps()
    end

    create index(:applications, [:listing_id])
    create index(:applications, [:user_id])
  end
end
