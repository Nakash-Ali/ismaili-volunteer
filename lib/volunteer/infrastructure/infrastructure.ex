defmodule Volunteer.Infrastructure do
  import Ecto.Query
  alias Volunteer.Repo

  alias Volunteer.Infrastructure.Region
  alias Volunteer.Infrastructure.Group
  alias Volunteer.Infrastructure.Jamatkhana
  alias Volunteer.Permissions

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

  def get_region_id_choices do
    from(r in Region, select: {r.title, r.id})
    |> Repo.all()
  end

  def get_regions(opts \\ []) do
    from(r in Region)
    |> query_regions_with_filters(Keyword.get(opts, :filters, %{}))
    |> order_by([asc: :id])
    |> Repo.all()
  end

  def region_preloadables() do
    [:parent, {:children, from(r in Region, order_by: r.title)}, {:groups, from(g in Group, order_by: g.title)}]
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

  def create_group!(attrs, region \\ nil) do
    %Group{}
    |> Group.changeset(attrs, region)
    |> Repo.insert!()
  end

  def get_group!(id) do
    Group |> Repo.get!(id)
  end

  def get_group(id) do
    Group |> Repo.get(id)
  end

  def get_groups() do
    from(r in Group)
    |> order_by([asc: :title])
    |> Repo.all()
  end

  def get_group_id_choices do
    from(g in Group, select: {g.title, g.id})
    |> Repo.all()
  end

  def delete_group!(id) do
    %Group{id: id}
    |> Repo.delete!()
  end

  def create_jamatkhana!(attrs, region \\ nil) do
    %Jamatkhana{}
    |> Jamatkhana.changeset(attrs, region)
    |> Repo.insert!()
  end

  def get_jamatkhana!(id) do
    Jamatkhana |> Repo.get!(id)
  end

  def get_region_config(region_id, key_or_keys) do
    VolunteerHardcoded.Regions.fetch_config(region_id, key_or_keys)
  end

  def get_region_config!(region_id, key_or_keys) do
    VolunteerHardcoded.Regions.fetch_config!(region_id, key_or_keys)
  end

  def get_region_config!(region_id) do
    VolunteerHardcoded.Regions.fetch_config!(region_id)
  end

  def annotate(%Region{} = region, options) do
    Enum.reduce(options, region, fn
      :hardcoded, region ->
        Map.put(
          region,
          :hardcoded,
          get_region_config!(region.id)
        )

      :roles, region ->
        Map.put(
          region,
          :roles,
          Permissions.region_roles(region.id)
        )

      {:groups, group_options}, region ->
        Map.update!(
          region,
          :groups,
          fn groups -> Enum.map(groups, &annotate(&1, group_options)) end
        )
    end)
  end

  def annotate(%Group{} = group, options) do
    Enum.reduce(options, group, fn
      :roles, group ->
        Map.put(
          group,
          :roles,
          Permissions.group_roles(group.id)
        )
    end)
  end

  def jamatkhana_choices() do
    VolunteerHardcoded.Regions.take_from_all!(:jamatkhanas)
    |> Enum.flat_map(fn {_key, value} -> value end)
    |> Enum.sort()
  end

  def seed_region!(id, attrs, parent) do
    %Region{}
    |> Region.changeset(attrs, parent)
    |> Volunteer.Repo.seed!(id)
  end

  def seed_group!(id, attrs, region) do
    %Group{}
    |> Group.changeset(attrs, region)
    |> Volunteer.Repo.seed!(id)
  end
end
