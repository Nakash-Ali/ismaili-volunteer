defmodule Volunteer.Repo.Migrations.MovePreferredContactToUser do
  use Ecto.Migration

  def change do
    alter table(:applicants) do
      remove :preferred_contact
    end
    alter table(:users) do
      add :preferred_contact, {:array, :string}, default: [], null: false
    end
  end
end
