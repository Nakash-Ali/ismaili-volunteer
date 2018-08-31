defmodule Volunteer.Repo.Migrations.CreateAddresses do
  use Ecto.Migration

  def change do
    create table(:addresses) do
      add :city, :string, null: false
      add :region, :string, null: false
      add :code, :string, null: false
      add :country, :string, null: false
      add :line_1, :string, null: false

      add :line_2, :string, null: true
      add :line_3, :string, null: true
      add :line_4, :string, null: true

      timestamps()
    end
  end
end
