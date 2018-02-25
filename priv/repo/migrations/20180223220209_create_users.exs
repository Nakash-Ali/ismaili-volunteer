defmodule Volunteer.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :title, :string, null: false
      add :given_name, :string, null: false
      add :sur_name, :string, null: false
      add :primary_email, :string, null: false
      add :is_admin, :boolean, default: false, null: false

      timestamps()
    end

  end
end
