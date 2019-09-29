defmodule Volunteer.Permissions.Ruleset do
  alias Volunteer.Infrastructure.Region
  alias Volunteer.Infrastructure.Group
  alias Volunteer.Listings.Listing

  @system_admins [
    "alizain.feerasta@iicanada.net",
  ]

  @super_admins [
    "alizain.feerasta@iicanada.net",
    "hussein.kermally@iicanada.net",
    # TODO: change rulesets so that we don't have to make her super_admin, and
    # permissions from the Canada region filter down to sub-regions and groups.
    "aliya.shivji@iicanada.net"
  ]

  def evaluate(user, action, subject, [rule | ruleset]) do
    rule
    |> apply_with_rescue([user, action, subject])
    |> case do
      result when result in [:allow, :deny] ->
        result

      nil ->
        evaluate(user, action, subject, ruleset)
    end
  end

  def evaluate(_user, _action, _subject, []) do
    :deny
  end

  def apply_with_rescue(func, args) do
    try do
      apply(func, args)
    rescue
      FunctionClauseError -> nil
    end
  end

  def admin_ruleset() do
    default_ruleset() ++ user_ruleset() ++ region_ruleset() ++ group_ruleset() ++ listing_ruleset()
  end

  def default_ruleset() do
    [
      fn %{primary_email: primary_email}, [:admin, :system | _], _subject ->
        if Enum.member?(@system_admins, primary_email) do
          :allow
        else
          :deny
        end
      end,
      fn %{primary_email: primary_email}, _action, _subject when primary_email in @super_admins ->
        :allow
      end
    ]
  end

  def user_ruleset() do
    [
      fn _user, [:admin, :user | _], _subject ->
        :deny
      end
    ]
  end

  def region_ruleset() do
    [
      fn _user, [:admin, :region, action], _subject when action in [:index, :show] ->
        :allow
      end,
      fn _user, [:admin, :region, :role, :index], _subject ->
        :allow
      end,
      fn %{roles_by_subject: %{region: region_roles}}, [:admin, :region, :role | _], %Region{id: region_id} ->
        if region_roles[region_id] in ["admin"] do
          :allow
        end
      end,
    ]
  end

  def group_ruleset() do
    [
      fn _user, [:admin, :group, action], _subject when action in [:index, :show] ->
        :allow
      end,
      fn _user, [:admin, :group, :role, :index], _subject ->
        :allow
      end,
      fn %{roles_by_subject: %{group: group_roles}}, [:admin, :group, :role | _], %Group{id: group_id} ->
        if group_roles[group_id] in ["admin"] do
          :allow
        end
      end,
      fn %{roles_by_subject: %{region: region_roles}}, [:admin, :group, :role | _], %Group{region_id: region_id} ->
        if region_roles[region_id] in ["admin"] do
          :allow
        end
      end,
    ]
  end

  def listing_ruleset() do
    [
      fn %{roles_by_subject: %{region: region_roles}}, [:admin, :listing | _], %Listing{region_id: region_id} ->
        if region_roles[region_id] in ["admin", "cc_team"] do
          :allow
        end
      end,
      fn %{roles_by_subject: %{group: group_roles}}, [:admin, :listing | _], %Listing{group_id: group_id} ->
        if group_roles[group_id] in ["admin"] do
          :allow
        end
      end,
      fn _user, [:admin, :listing, action], _subject when action in [:index, :create] ->
        :allow
      end,
      fn %{roles_by_subject: %{listing: listing_roles}}, [:admin, :listing, action], %Listing{id: listing_id} when action in [:show, :update, :request_approval, :refresh_expiry, :expire] ->
        if listing_roles[listing_id] in ["admin"] do
          :allow
        end
      end,
      fn %{roles_by_subject: %{listing: listing_roles}}, [:admin, :listing, action | _], %Listing{id: listing_id} when action in [:role, :applicant, :tkn_listing, :marketing_request] ->
        if listing_roles[listing_id] in ["admin"] do
          :allow
        end
      end,
      fn %{roles_by_subject: %{listing: listing_roles}}, [:admin, :listing | action], %Listing{id: listing_id} when action in [
        [:show],
        [:role, :index],
        [:applicant, :index],
        [:tkn_listing, :show],
        [:tkn_listing, :spec],
        [:marketing_request, :show],
      ] ->
        if listing_roles[listing_id] in ["read-only"] do
          :allow
        end
      end,
    ]
  end
end
