defmodule Volunteer.PermissionsTest do
  use Volunteer.DataCase
  alias Volunteer.Permissions
  alias Volunteer.TestSupport.Factory

  defmacro assert_all_is_allowed(result, user, subject, actions_list) when is_list(actions_list) do
    asserts =
      Enum.map(actions_list, fn action ->
        quote do
          assert unquote(result) == Volunteer.Permissions.is_allowed?(unquote(user), unquote(action), unquote(subject))
        end
      end)

    quote do
      unquote(asserts)
    end
  end

  describe "annotate_roles_for_user/1" do
    test "simple", _context do
      user = Factory.user!
      region = Factory.region!

      Volunteer.Roles.create(:region, region.id, %{user_id: user.id, relation: "admin"})

      role =
        user
        |> Volunteer.Repo.preload([:roles])
        |> Permissions.annotate_roles_for_user
        |> Map.get(:roles_by_subject, %{})
        |> Map.get(:region, %{})
        |> Map.get(region.id, nil)

      assert role == "admin"
    end
  end

  describe "is_allowed/3" do
    test "things everyone can and cannot do to a region" do
      assert_all_is_allowed(true, %{roles_by_subject: %{}}, %Volunteer.Listings.Listing{id: 1}, [
        [:admin, :region, :index],
        [:admin, :region, :show],
        [:admin, :region, :role, :index],
      ])
      assert_all_is_allowed(false, %{roles_by_subject: %{}}, %Volunteer.Listings.Listing{id: 1}, [
        [:admin, :region, :role, :new],
        [:admin, :region, :role, :create],
        [:admin, :region, :role, :delete],
      ])
    end

    test "things everyone can and cannot do to a group" do
      assert_all_is_allowed(true, %{roles_by_subject: %{}}, %Volunteer.Listings.Listing{id: 1}, [
        [:admin, :group, :index],
        [:admin, :group, :show],
        [:admin, :group, :role, :index],
      ])
      assert_all_is_allowed(false, %{roles_by_subject: %{}}, %Volunteer.Listings.Listing{id: 1}, [
        [:admin, :group, :role, :new],
        [:admin, :group, :role, :create],
        [:admin, :group, :role, :delete],
      ])
    end

    test "things everyone can do when creating listings" do
      assert_all_is_allowed(true, %{roles_by_subject: %{}}, nil, [
        [:admin, :listing, :new],
        [:admin, :listing, :create],
      ])
    end

    test "things everyone can and cannot do to a listing" do
      assert_all_is_allowed(true, %{roles_by_subject: %{}}, %Volunteer.Listings.Listing{id: 1}, [
        [:admin, :listing, :show],
        [:admin, :listing, :tkn, :show],
        [:admin, :listing, :role, :index],
      ])
      assert_all_is_allowed(false, %{roles_by_subject: %{}}, %Volunteer.Listings.Listing{id: 1}, [
        [:admin, :listing, :edit],
        [:admin, :listing, :update],
        [:admin, :listing, :public, :approve],
        [:admin, :listing, :public, :unapprove],
        [:admin, :listing, :public, :request_approval],
        [:admin, :listing, :public, :refresh],
        [:admin, :listing, :public, :expire],
        [:admin, :listing, :public, :reset],
        [:admin, :listing, :role, :new],
        [:admin, :listing, :role, :create],
        [:admin, :listing, :role, :delete],
        [:admin, :listing, :applicant, :index],
        [:admin, :listing, :applicant, :export],
        [:admin, :listing, :tkn, :edit],
        [:admin, :listing, :tkn, :update],
        [:admin, :listing, :tkn, :spec],
        [:admin, :listing, :marketing_request, :new],
        [:admin, :listing, :marketing_request, :create],
      ])
    end

    test "things a listing admin can and cannot do to a listing" do
      user = %{
        roles_by_subject: %{
          listing: %{1 => "admin"}
        }
      }

      listing = %Volunteer.Listings.Listing{id: 1}

      assert_all_is_allowed(true, user, listing, [
        [:admin, :listing, :edit],
        [:admin, :listing, :update],
        [:admin, :listing, :public, :request_approval],
        [:admin, :listing, :public, :refresh],
        [:admin, :listing, :public, :expire],
        [:admin, :listing, :public, :reset],
        [:admin, :listing, :role, :new],
        [:admin, :listing, :role, :create],
        [:admin, :listing, :role, :delete],
        [:admin, :listing, :applicant, :index],
        [:admin, :listing, :applicant, :export],
        [:admin, :listing, :tkn, :edit],
        [:admin, :listing, :tkn, :update],
        [:admin, :listing, :tkn, :spec],
        [:admin, :listing, :marketing_request, :new],
        [:admin, :listing, :marketing_request, :create],
      ])

      assert_all_is_allowed(false, user, listing, [
        [:admin, :listing, :public, :approve],
        [:admin, :listing, :public, :unapprove],
      ])
    end
  end
end
