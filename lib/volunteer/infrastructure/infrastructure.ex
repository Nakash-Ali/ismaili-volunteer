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

  def get_region_by_slug(slug_like_str) do
    slug = Region.slugify(slug_like_str)
    from(r in Region, where: r.slug == ^slug)
    |> Repo.one()
  end

  def create_group!(attrs, region \\ nil) do
    %Group{}
    |> Group.changeset(attrs, region)
    |> Repo.insert!()
  end

  def get_group!(id) do
    Group |> Repo.get!(id)
  end

  def get_regions(opts \\ []) do
    from(r in Region)
    |> query_regions_with_filters(Keyword.get(opts, :filters, %{}))
    |> Repo.all()
  end

  defp query_regions_with_filters(query, %{parent_id: parent_id, parent_in_path: true}) when is_integer(parent_id) do
    from(r in query, where: r.parent_id == ^parent_id or fragment("?::integer[] && ?", [^parent_id], r.parent_path))
  end

  defp query_regions_with_filters(query, %{parent_id: parent_id}) when is_integer(parent_id) do
    from(r in query, where: r.parent_id == ^parent_id)
  end

  defp query_regions_with_filters(query, _filters) do
    query
  end

  def get_region_id_choices do
    from(r in Region, select: {r.title, r.id})
    |> Repo.all()
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

  def get_region_config(region_id, key) do
    Volunteer.Infrastructure.HardcodedConfig.get_region_config(region_id, key)
  end
end
