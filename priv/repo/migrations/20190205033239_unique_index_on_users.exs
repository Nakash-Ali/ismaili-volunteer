defmodule Volunteer.Repo.Migrations.UniqueIndexOnUsers do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:given_name, :sur_name, :primary_email, :primary_phone], name: "users_unique_index")
  end
end
