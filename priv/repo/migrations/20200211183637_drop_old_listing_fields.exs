defmodule Volunteer.Repo.Migrations.DropOldListingFields do
  use Ecto.Migration

  def up do
    alter table(:listings) do
      remove :expiry_date
      remove :expiry_reminder_sent

      remove :approved
      remove :approved_on
      remove :approved_by_id
    end

    drop_if_exists table(:tkn_listings)
  end
end
