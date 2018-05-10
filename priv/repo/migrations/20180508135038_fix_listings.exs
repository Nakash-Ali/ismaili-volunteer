defmodule Volunteer.Repo.Migrations.FixListings do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      remove :vulnerable_sector_check
    end
  end
end
