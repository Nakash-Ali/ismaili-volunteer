defmodule Volunteer.Repo.Migrations.RenamePublicListingFields do
  use Ecto.Migration

  def up do
    alter table(:listings) do
      add :public_expiry_date, :timestamptz, null: true
      add :public_expiry_reminder_sent, :boolean, default: false, null: true

      add :public_approved, :boolean, default: false, null: true
      add :public_approved_on, :timestamptz, null: true
      add :public_approved_by_id, references(:users, on_delete: :restrict), null: true
    end

    flush()

    execute "UPDATE listings SET public_expiry_date = expiry_date"
    execute "UPDATE listings SET public_expiry_reminder_sent = expiry_reminder_sent"
    execute "UPDATE listings SET public_approved = approved"
    execute "UPDATE listings SET public_approved_on = approved_on"
    execute "UPDATE listings SET public_approved_by_id = approved_by_id"

    execute "ALTER TABLE listings ALTER COLUMN public_expiry_reminder_sent SET NOT NULL;"
    execute "ALTER TABLE listings ALTER COLUMN public_approved SET NOT NULL;"

    create index(:listings, [:public_approved_by_id])
  end

  def down do
    drop_if_exists index(:listings, [:public_approved_by_id])

    alter table(:listings) do
      remove :public_expiry_date
      remove :public_expiry_reminder_sent

      remove :public_approved
      remove :public_approved_on
      remove :public_approved_by_id
    end
  end
end
