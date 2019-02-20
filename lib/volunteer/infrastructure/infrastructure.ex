defmodule Volunteer.Infrastructure do
  import Ecto.Query, warn: false
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

  def get_groups() do
    from(r in Group)
    |> order_by([asc: :id])
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

  def get_region_config!(region_id) do
    Volunteer.Infrastructure.HardcodedConfig.get_region_config!(region_id)
  end

  def get_region_config(region_id, key_or_keys) do
    Volunteer.Infrastructure.HardcodedConfig.get_region_config(region_id, key_or_keys)
  end

  def get_region_config!(region_id, key_or_keys) do
    {:ok, config} = get_region_config(region_id, key_or_keys)
    config
  end

  def aggregate_from_all_regions(key_or_keys, opts \\ %{}) do
    Volunteer.Infrastructure.HardcodedConfig.aggregate_from_all_regions(key_or_keys, opts)
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
          Permissions.get_for_region(region.id)
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
          Permissions.get_for_group(group.id)
        )
    end)
  end

  def jamatkhana_choices() do
    {:ok, jamatkhanas} =
      Volunteer.Infrastructure.aggregate_from_all_regions(:jamatkhanas)

    Enum.sort(jamatkhanas)
  end

  def seed_region!(id, title, parent) do
    seed_region!(id, title, nil, parent)
  end

  def seed_region!(id, title, slug, parent) do
    %Region{}
    |> Region.changeset(
      %{
        title: title,
        slug: slug
      },
      parent
    )
    |> Volunteer.Repo.seed!(id)
  end

  def seed_group!(id, title, region) do
    %Group{}
    |> Group.changeset(
      %{
        title: title
      },
      region
    )
    |> Volunteer.Repo.seed!(id)
  end
end
