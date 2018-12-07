defmodule Volunteer.Repo.Migrations.RenameWorkExperienceColumnTKNListing do
  use Ecto.Migration

  def change do
    rename table(:tkn_listings), :work_experience_level, to: :work_experience_years
  end
end
