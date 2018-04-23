defmodule Volunteer.Repo.Migrations.AddVulnerableSectorCheckBooleanToListings do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      add :vulnerable_sector_check, :boolean, default: false, null: false
    end
  end
end
