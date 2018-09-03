defmodule Volunteer.Permissions.Ruleset do
  alias Volunteer.Accounts.User
  alias Volunteer.Apply.Listing

  @admin_listing_member_actions [
    :show,
    :update,
    :delete,
    :refresh_expiry,
    :tkn_listing,
    :marketing_request,
    :applicant
  ]

  def evaluate(user, action, subject, [rule | ruleset]) do
    rule
    |> apply_with_rescue([user, action, subject])
    |> case do
      result when result in [:allow, :deny] ->
        result

      nil ->
        evaluate?(user, action, subject, ruleset)
    end
  end

  def evaluate(_user, _action, _subject, []) do
    :deny
  end

  def admin_ruleset() do
    [
      fn %User{}, [:admin, :listing, action | _], _
         when action in [:index, :create] ->
        :allow
      end,
      fn %User{id: user_id}, [:admin, :listing, action | _], %Listing{created_by_id: user_id}
         when action in @admin_listing_member_actions ->
        :allow
      end,
      fn %User{id: user_id}, [:admin, :listing, action | _], %Listing{organized_by_id: user_id}
         when action in @admin_listing_member_actions ->
        :allow
      end,
      fn %{region_roles: region_roles}, [:admin, :listing | _], %Listing{region_id: region_id} ->
        if region_roles[region_id] == "admin" do
          :allow
        end
      end,
      fn %{group_roles: group_roles}, [:admin, :listing | _], %Listing{group_id: group_id} ->
        if group_roles[group_id] == "admin" do
          :allow
        end
      end
    ]
  end

  def true_or_nil(true), do: true
  def true_or_nil(_), do: nil

  def apply_with_rescue(func, args) do
    try do
      apply(func, args)
    rescue
      FunctionClauseError -> nil
    end
  end
end
