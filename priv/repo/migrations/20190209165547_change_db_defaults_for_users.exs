defmodule Volunteer.Repo.Migrations.ChangeDBDefaultsForUsers do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE users ALTER COLUMN primary_phone DROP DEFAULT"
    execute "ALTER TABLE users ALTER COLUMN education_level DROP DEFAULT"
  end

  def down do
    alter table(:users) do
      modify :primary_phone, :string, null: false, default: ""
      modify :education_level, :string, null: false, default: ""
    end
  end
end
