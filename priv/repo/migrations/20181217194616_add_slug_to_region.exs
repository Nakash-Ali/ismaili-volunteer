defmodule Volunteer.Repo.Migrations.AddSlugToRegion do
  use Ecto.Migration
  import Ecto.Query

  def up do
    alter table(:regions) do
      add :slug, :string
    end

    create unique_index(:regions, [:slug])

    flush()

    from(r in Volunteer.Infrastructure.Region, select: r)
    |> Volunteer.Repo.all()
    |> Enum.map(fn region ->
      region
      |> Ecto.Changeset.change(%{
        slug: Volunteer.Infrastructure.Region.slugify(region.title)
      })
      |> Volunteer.Repo.update!()
    end)

    alter table(:regions) do
      modify :slug, :string, null: false
    end
  end

  def down do
    alter table(:regions) do
      remove :slug
    end
  end
end
