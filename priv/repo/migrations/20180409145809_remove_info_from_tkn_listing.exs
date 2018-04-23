defmodule Volunteer.Repo.Migrations.RemoveInfoFromTKNListing do
  use Ecto.Migration

  def change do
    alter table(:tkn_listings) do
      remove :enabled
    end
  end
end
