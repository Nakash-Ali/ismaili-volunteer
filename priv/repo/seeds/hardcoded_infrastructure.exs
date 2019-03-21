Volunteer.Repo.transaction(fn ->
  Volunteer.Repo.query!("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;")

  regions_by_id =
    VolunteerHardcoded.Regions.config_by_id()
    |> Enum.reduce(%{}, fn {region_id, region_config}, regions_by_id ->
      region_attrs =
        Map.take(region_config, [:title, :slug])

      region_parent =
        case region_config.parent_id do
          parent_id when not is_nil(parent_id) ->
            Map.fetch!(regions_by_id, parent_id)

          _ ->
            nil
        end

      region = Volunteer.Infrastructure.seed_region!(region_id, region_attrs, region_parent)

      Map.put(regions_by_id, region_id, region)
    end)

  groups_by_id =
    VolunteerHardcoded.Groups.config_by_id()
    |> Enum.reduce(%{}, fn
      {group_id, :delete}, groups_by_id ->
        case Volunteer.Infrastructure.get_group(group_id) do
          nil ->
            nil

          _ ->
            Volunteer.Infrastructure.delete_group!(group_id)
        end

        groups_by_id

      {group_id, group_config}, groups_by_id ->
        group_attrs =
          Map.take(group_config, [:title])

        group_region =
          Map.fetch!(regions_by_id, group_config.region_id)

        group = Volunteer.Infrastructure.seed_group!(group_id, group_attrs, group_region)

        Map.put(groups_by_id, group_id, group)
    end)

  {:ok, {regions_by_id, groups_by_id}}
end)
