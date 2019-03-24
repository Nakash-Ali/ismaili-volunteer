defmodule VolunteerHardcoded.UserTest do
  use ExUnit.Case
  alias VolunteerHardcoded.User

  describe "hydrate_actual_users/1" do
    test "works" do
      input = [
        %VolunteerHardcoded.User{primary_email: "a@me.com"},
        %VolunteerHardcoded.User{primary_email: "b@me.com"},
        %VolunteerHardcoded.User{primary_email: "c@me.com"},
      ]
      expected = [
        %VolunteerHardcoded.User{primary_email: "a@me.com"},
        %VolunteerHardcoded.User{primary_email: "b@me.com"},
        %Volunteer.Accounts.User{primary_email: "c@me.com"},
      ]
      get_user_by_primary_email_func = fn
        primary_email when primary_email in ["c@me.com"] ->
          %Volunteer.Accounts.User{primary_email: primary_email}

        _ ->
          nil
      end
      assert User.hydrate_actual_users(input, get_user_by_primary_email_func) == expected
    end
  end
end
