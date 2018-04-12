defmodule Volunteer.Repo.Migrations.RemoveTKNFromListingSchema do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      remove :tkn_eligible
    end
  end
end
