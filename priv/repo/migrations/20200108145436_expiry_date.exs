defmodule Volunteer.Repo.Migrations.ExpiryDate do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE listings ALTER COLUMN expiry_date DROP NOT NULL;"
  end

  def down do
    execute "ALTER TABLE listings ALTER COLUMN expiry_date SET NOT NULL;"
  end
end
