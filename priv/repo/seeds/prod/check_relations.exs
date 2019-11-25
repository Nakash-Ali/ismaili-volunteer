# TODO: validate that this works correctly in production

Volunteer.Repo.transaction(fn ->
  Volunteer.Repo.query!("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;")

  Volunteer.Roles.Role
  |> Volunteer.Repo.all
  |> Enum.map(fn role ->
    role
    |> Volunteer.Roles.Role.validate_and_upgrade_relation
    |> Volunteer.Repo.insert_or_update!
  end)
end)
