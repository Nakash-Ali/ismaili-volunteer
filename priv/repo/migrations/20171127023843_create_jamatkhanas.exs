defmodule Volunteer.Repo.Migrations.CreateJamatkhanas do
  use Ecto.Migration

  def change do
    create table(:jamatkhanas) do
      add :title, :string
      add :address_line_1, :string
      add :address_line_2, :string, null: true
      add :address_line_3, :string, null: true
      add :address_line_4, :string, null: true
      add :address_city, :string
      add :address_province_state, :string
      add :address_country, :string
      add :address_postal_zip_code, :string
      add :region, references(:regions, on_delete: :restrict)

      timestamps()
    end

    create index(:jamatkhanas, [:region])
  end
end
