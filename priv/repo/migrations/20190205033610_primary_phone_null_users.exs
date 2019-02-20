defmodule Volunteer.Repo.Migrations.PrimaryPhoneNullUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :primary_phone, :string, null: false, default: ""
    end
  end
end
