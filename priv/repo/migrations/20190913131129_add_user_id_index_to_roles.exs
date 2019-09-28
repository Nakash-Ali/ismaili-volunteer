defmodule Volunteer.Repo.Migrations.AddUserIdIndexToRoles do
  use Ecto.Migration

  def change do
    create index(:roles, [:user_id])
  end
end
