defmodule Volunteer.Repo.Migrations.ChangePreferredContactToArray do
  use Ecto.Migration

  def change do
    alter table(:applicants) do
      remove :preferred_contact
      add :preferred_contact, {:array, :string}, default: [], null: false
    end
  end
end
