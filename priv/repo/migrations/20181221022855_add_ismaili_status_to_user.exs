defmodule Volunteer.Repo.Migrations.AddIsmailiStatusToUser do
  use Ecto.Migration
  import Ecto.Query

  def up do
    alter table(:users) do
      add :ismaili_status, :string
    end

    flush()

    from(u in Volunteer.Accounts.User, select: [:id])
    |> Volunteer.Repo.all()
    |> Enum.map(fn user ->
      user
      |> Ecto.Changeset.change(%{ismaili_status: ""})
      |> Volunteer.Repo.update!()
    end)

    alter table(:users) do
      modify :ismaili_status, :string, null: false
    end
  end

  def down do
    alter table(:users) do
      remove :ismaili_status
    end
  end
end
