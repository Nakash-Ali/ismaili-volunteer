defmodule Volunteer.Repo.Migrations.AddQualificationsRequiredToListing do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      add :qualifications_required, {:array, :string}, default: [], null: false
    end
  end
end
