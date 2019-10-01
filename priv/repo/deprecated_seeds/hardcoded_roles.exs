# TODO: delete this when RoleController.create/2 & RoleController.delete/2 have
# been stabilized and enabled

Volunteer.Repo.transaction(fn ->
  Volunteer.Repo.query!("SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;")

  Volunteer.Repo.delete_all(Volunteer.Roles.Role)

  # Add roles from hardcoded
  VolunteerHardcoded.Roles.roles_by_primary_email()
  |> Enum.each(fn {primary_email, roles_by_subject_type} ->
    case Volunteer.Accounts.get_user_by_primary_email(primary_email) do
      %Volunteer.Accounts.User{} = user ->
        Enum.each(roles_by_subject_type, fn {subject_type, roles_by_subject_id} ->
          Enum.each(roles_by_subject_id, fn {subject_id, relation} ->
            {:ok, _role} =
              Volunteer.Roles.create_subject_role(
                subject_type,
                subject_id,
                %{user_id: user.id, relation: relation}
              )
          end)
        end)

      _ ->
        IO.puts("No user found for #{primary_email}")
    end
  end)

  # Add roles from listings
  Volunteer.Repo.all(Volunteer.Listings.Listing)
  |> Enum.each(fn listing ->
    {:ok, _role} =
      Volunteer.Roles.create_subject_role(
        :listing,
        listing.id,
        %{user_id: listing.created_by_id, relation: "admin"}
      )

    if listing.created_by_id != listing.organized_by_id do
      {:ok, _role} =
        Volunteer.Roles.create_subject_role(
          :listing,
          listing.id,
          %{user_id: listing.organized_by_id, relation: "admin"}
        )
    end
  end)

  :ok
end)
