defmodule Volunteer.Repo.Migrations.AddTimeCommitmentTypeToListings do
  use Ecto.Migration
  import Ecto.Query

  def up do
    alter table(:listings) do
      add :time_commitment_amount, :integer
      add :time_commitment_type, :string
    end

    flush()

    from(l in Volunteer.Listings.Listing, select: l)
    |> Volunteer.Repo.all()
    |> Enum.map(fn listing ->
      listing
      |> Ecto.Changeset.change(%{
          time_commitment_amount: listing.hours_per_week,
          time_commitment_type: "hour(s)/week",
        })
      |> Volunteer.Repo.update!()
    end)

    alter table(:listings) do
      modify :time_commitment_amount, :integer, null: false
      modify :time_commitment_type, :string, null: false
    end
  end

  def down do
    alter table(:listings) do
      remove :time_commitment_amount
      remove :time_commitment_type
    end
  end
end
