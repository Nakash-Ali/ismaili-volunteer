defmodule Volunteer.Repo.Migrations.AddCCEmailsToListing do
  use Ecto.Migration

  def change do
    alter table(:listings) do
      add :cc_emails, :text, default: "", null: false
    end
  end
end
