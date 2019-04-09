defmodule VolunteerHardcoded.RolesTest do
  use ExUnit.Case
  alias VolunteerHardcoded.Roles

  # TODO: these tests are super brittle, fix them!

  describe "scope_roles/1" do
    test "region" do
      assert Roles.scope_roles(:region, 2) == %{"nabeela.haji@iicanada.net" => "admin", "zahra.nurmohamed@iicanada.net" => "cc_team"}
    end

    test "group" do
      assert Roles.scope_roles(:group, 3) == %{"rahima.alani2@iicanada.net" => "admin", "armeen.dhanjee@iicanada.net" => "admin"}
    end
  end

  describe "scope_roles/2" do
    test "region" do
      assert Roles.scope_roles(:region, 2, ["cc_team"]) == %{"zahra.nurmohamed@iicanada.net" => "cc_team"}
    end

    test "group" do
      assert Roles.scope_roles(:group, 3, ["admin"]) == %{"rahima.alani2@iicanada.net" => "admin", "armeen.dhanjee@iicanada.net" => "admin"}
      assert Roles.scope_roles(:group, 3, ["cc_team"]) == %{}
    end
  end

  describe "user_roles/2" do
    test "for group & user permissions" do
      assert Roles.user_roles(%{primary_email: "riyaz.virani@iicanada.net"}, :group) == %{22 => "admin", 23 => "admin"}
    end
  end

  describe "user_roles/3" do
    test "for group & user permissions" do
      assert Roles.user_roles(%{primary_email: "zahra.nurmohamed@iicanada.net"}, :group, ["admin"]) == %{57 => "admin"}
      assert Roles.user_roles(%{primary_email: "zahra.nurmohamed@iicanada.net"}, :group, ["cc_team"]) == %{}
      assert Roles.user_roles(%{primary_email: "zahra.nurmohamed@iicanada.net"}, :region, ["admin"]) == %{}
      assert Roles.user_roles(%{primary_email: "zahra.nurmohamed@iicanada.net"}, :region, ["cc_team"]) == %{2 => "cc_team"}
    end
  end
end
