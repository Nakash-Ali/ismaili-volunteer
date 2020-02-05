defmodule Volunteer.Repo.Migrations.AddBoolForTKNAssignmentSpec do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      add :tkn_assignment_spec_sent, :boolean, default: :false, null: false
    end
  end
end
