defmodule Volunteer.Repo.Migrations.RemoveFieldsFromGroup do
  use Ecto.Migration

  def change do
    alter table(:groups) do
      remove :parent_path
      remove :parent_id
    end

    drop_if_exists index(:groups, [:parent_path])
    drop_if_exists index(:groups, [:parent_id])
  end
end
