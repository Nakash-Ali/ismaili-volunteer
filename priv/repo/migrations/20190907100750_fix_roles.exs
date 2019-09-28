defmodule Volunteer.Repo.Migrations.FixRoles do
  use Ecto.Migration

  def change do
    drop table(:roles)
  end
end
