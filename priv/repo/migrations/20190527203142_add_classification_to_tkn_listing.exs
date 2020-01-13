defmodule Volunteer.Repo.Migrations.AddClassificationToTKNListing do
  use Ecto.Migration
  import Ecto.Query

  def up do
    alter table(:tkn_listings) do
      add :classification, :string
    end

    flush()

    from(u in "tkn_listings", select: [:id])
    |> Volunteer.Repo.all()
    |> Enum.map(fn user ->
      user
      |> Ecto.Changeset.change(%{classification: ""})
      |> Volunteer.Repo.update!()
    end)

    alter table(:tkn_listings) do
      modify :classification, :string, null: false
    end
  end

  def down do
    alter table(:tkn_listings) do
      remove :classification
    end
  end
end
