defmodule VolunteerHardcoded.User do
  defstruct [primary_email: nil]

  def hydrate_actual_users(
    users,
    get_user_by_primary_email_func \\ &Volunteer.Accounts.get_user_by_primary_email/1
  ) do
    Enum.map(users, fn
      %__MODULE__{primary_email: primary_email} = hardcoded_user ->
        case get_user_by_primary_email_func.(primary_email) do
          nil ->
            hardcoded_user

          user ->
            user
        end

      %Volunteer.Accounts.User{} = user ->
        user
    end)
  end
end
