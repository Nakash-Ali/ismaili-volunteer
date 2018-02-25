defmodule Volunteer.Repo.Migrations.CreateIdentities do
  use Ecto.Migration

  def change do
    create table(:identities) do
      add :provider, :string, null: false
      add :provider_id, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:identities, [:user_id])
    create unique_index(:identities, [:provider, :provider_id])
  end
end
