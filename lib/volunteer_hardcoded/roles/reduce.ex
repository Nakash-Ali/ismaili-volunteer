defmodule VolunteerHardcoded.Roles.Reduce do
  def by_primary_email(roles_by_scope) do
    Enum.reduce(roles_by_scope, %{}, fn {scope_type, roles_for_scope_type}, roles_by_primary_email ->
      Enum.reduce(roles_for_scope_type, roles_by_primary_email, fn {scope_id, roles_for_scope_id}, roles_by_primary_email ->
        Enum.reduce(roles_for_scope_id, roles_by_primary_email, fn {primary_email, roles}, roles_by_primary_email ->
          VolunteerUtils.Map.update_always(roles_by_primary_email, primary_email, %{}, fn user_roles ->
            VolunteerUtils.Map.update_always(user_roles, scope_type, %{}, fn user_roles_for_scope ->
              Map.put(user_roles_for_scope, scope_id, roles)
            end)
          end)
        end)
      end)
    end)
  end
end
