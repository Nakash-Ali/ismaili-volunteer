defmodule Volunteer.Repo.Migrations.AddOpaqueIdToApplicants do
  use Ecto.Migration

  def change do
    alter table(:applicants) do
      add :opaque_id, :uuid, default: fragment("uuid_generate_v4()"), null: false
    end
  end
end
