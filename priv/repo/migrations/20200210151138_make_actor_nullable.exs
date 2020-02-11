defmodule Volunteer.Repo.Migrations.MakeActorNullable do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE logs ALTER COLUMN actor_id DROP NOT NULL;"
  end

  def down do
    execute "ALTER TABLE logs ALTER COLUMN actor_id SET NOT NULL;"
  end
end
