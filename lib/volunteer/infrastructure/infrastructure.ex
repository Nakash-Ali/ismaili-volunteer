defmodule Volunteer.Infrastructure do
  import Ecto.Query, warn: false
  alias Volunteer.Repo

  alias Volunteer.Infrastructure.Region
  alias Volunteer.Infrastructure.Group
  alias Volunteer.Infrastructure.Jamatkhana

  def create_region!(attrs, parent \\ nil) do
    %Region{}
    |> Region.changeset(attrs, parent)
    |> Repo.insert!()
  end

  def get_region!(id) do
    Region |> Repo.get!(id)
  end

  def create_group!(attrs, region \\ nil) do
    %Group{}
    |> Group.changeset(attrs, region)
    |> Repo.insert!()
  end

  def get_group!(id) do
    Group |> Repo.get!(id)
  end

  def get_group_id_choices do
    from(g in Group, select: {g.title, g.id})
    |> Repo.all()
  end

  def create_jamatkhana!(attrs, region \\ nil) do
    %Jamatkhana{}
    |> Jamatkhana.changeset(attrs, region)
    |> Repo.insert!()
  end

  def get_jamatkhana!(id) do
    Jamatkhana |> Repo.get!(id)
  end
end
