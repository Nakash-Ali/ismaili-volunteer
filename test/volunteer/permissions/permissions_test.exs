defmodule Volunteer.PermissionsTest do
  use Volunteer.DataCase
  alias Volunteer.Permissions

  describe "annotate_roles_for_user/1" do
    test "works for when there are no permissions" do
      assert Permissions.annotate_roles_for_user(%{primary_email: "alizain.feerasta@iicanada.net"}) == %{primary_email: "alizain.feerasta@iicanada.net", group_roles: %{}, region_roles: %{}}
    end

    test "works for the complex use-case" do
      assert Permissions.annotate_roles_for_user(%{primary_email: "zahra.nurmohamed@iicanada.net"}) == %{primary_email: "zahra.nurmohamed@iicanada.net", group_roles: %{57 => "admin"}, region_roles: %{2 => "cc_team"}}
    end
  end
end
