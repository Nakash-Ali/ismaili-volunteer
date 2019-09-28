defmodule Volunteer.PermissionsTest do
  use Volunteer.DataCase
  alias Volunteer.Permissions
  alias Volunteer.TestSupport.Factory

  describe "annotate_roles_for_user/1" do
    test "simple", context do
      user = Factory.user!
      region = Factory.region!

      Volunteer.Roles.create_subject_role(:region, region.id, %{user_id: user.id, relation: "admin"})

      role =
        user
        |> Permissions.annotate_roles_for_user
        |> Map.get(:roles_by_subject, %{})
        |> Map.get(:region, %{})
        |> Map.get(region.id, nil)

      assert role == "admin"
    end
  end
end
