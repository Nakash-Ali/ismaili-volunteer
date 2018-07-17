defmodule Volunteer.Repo.Migrations.ChangeNameOfApplicationsTable do
  use Ecto.Migration

  def change do
    rename table(:applications), to: table(:applicants)
  end
end
