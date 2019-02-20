defmodule Volunteer.Repo.Migrations.UniqueUserApplicationPerListing do
  use Ecto.Migration

  def change do
    create index(:applicants, [:listing_id, :user_id], unique: true)
  end
end
