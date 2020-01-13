defmodule Volunteer.Listings.InfraFilters do
  import Ecto.Query
  alias Volunteer.Infrastructure.Region

  def by_region(query, %{region_id: region_id, region_in_path: true}) when is_integer(region_id) do
    from(l in query,
      join: r in Region,
      on: l.region_id == r.id,
      where: r.id == ^region_id or fragment("?::integer[] && ?", [^region_id], r.parent_path))
  end

  def by_region(query, %{region_id: region_id}) when is_integer(region_id) do
    from(l in query, where: l.region_id == ^region_id)
  end

  def by_region(query, _filters) do
    query
  end

  def by_group(query, %{group_id: group_id}) when is_integer(group_id) do
    from(l in query, where: l.group_id == ^group_id)
  end

  def by_group(query, _filters) do
    query
  end
end
