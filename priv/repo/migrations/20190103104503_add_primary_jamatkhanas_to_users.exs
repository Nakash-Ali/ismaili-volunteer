defmodule Volunteer.Repo.Migrations.AddPrimaryJamatkhanasToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :primary_jamatkhanas, {:array, :string}, default: [], null: false
    end
  end
end
