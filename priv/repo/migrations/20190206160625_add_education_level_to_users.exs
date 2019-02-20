defmodule Volunteer.Repo.Migrations.AddEducationLevelToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :education_level, :string, null: false, default: ""
    end
  end
end
