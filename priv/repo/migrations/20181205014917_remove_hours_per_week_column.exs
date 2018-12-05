defmodule Volunteer.Repo.Migrations.RemoveHoursPerWeekColumn do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      remove :hours_per_week
    end
  end
end
