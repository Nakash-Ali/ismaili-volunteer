defmodule Volunteer.Repo.Migrations.AddExpiryReminderFlagToListings do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      add :expiry_reminder_sent, :boolean, default: false, null: false
    end
  end
end
