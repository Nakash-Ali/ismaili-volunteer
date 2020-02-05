defmodule Volunteer.Repo.Migrations.AddEOAEvaluationToTKNListing do
  use Ecto.Migration
  import Ecto.Query

  def up do
    alter table(:tkn_listings) do
      add :eoa_evaluation, :boolean
    end

    flush()

    from(u in "tkn_listings", select: [:id])
    |> Volunteer.Repo.all()
    |> Enum.map(fn user ->
      user
      |> Ecto.Changeset.change(%{eoa_evaluation: false})
      |> Volunteer.Repo.update!()
    end)

    alter table(:tkn_listings) do
      modify :eoa_evaluation, :boolean, null: false
    end
  end

  def down do
    alter table(:tkn_listings) do
      remove :eoa_evaluation
    end
  end
end
