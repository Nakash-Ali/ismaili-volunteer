# Insert functions

do_insert! = fn changeset, id ->
  changeset
  |> Ecto.Changeset.apply_changes()
  |> Map.put(:id, id)
  |> Volunteer.Repo.insert!(on_conflict: :replace_all, conflict_target: :id)
end

do_create_region = fn id, title, parent ->
  %Volunteer.Infrastructure.Region{}
  |> Volunteer.Infrastructure.Region.changeset(
    %{
      title: title
    },
    parent
  )
  |> do_insert!.(id)
end

do_create_group = fn id, title, region ->
  %Volunteer.Infrastructure.Group{}
  |> Volunteer.Infrastructure.Group.changeset(
    %{
      title: title
    },
    region
  )
  |> do_insert!.(id)
end

# Regions

canada = do_create_region.(1, "Canada", nil)

ontario = do_create_region.(2, "Ontario", canada)

# Groups

do_create_group.(1, "Council for Canada", canada)

do_create_group.(2, "Council for Ontario", ontario)
do_create_group.(3, "Aga Khan Education Board for Ontario", ontario)
do_create_group.(4, "Aga Khan Health Board for Ontario", ontario)
do_create_group.(5, "ITREB Ontario", ontario)
