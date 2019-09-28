defmodule Volunteer.Permissions.Actions do
  defmodule InvalidAction do
    defexception [:message, :action]
  end

  @actions MapSet.new([
    [:admin, :system, :env],
    [:admin, :system, :app],
    [:admin, :system, :endpoint],
    [:admin, :system, :req_headers],
    [:admin, :system, :spoof],

    [:admin, :user, :index],

    [:admin, :region, :index],
    [:admin, :region, :show],

    [:admin, :region, :role, :index],
    [:admin, :region, :role, :create],
    [:admin, :region, :role, :delete],

    [:admin, :group, :index],
    [:admin, :group, :show],

    [:admin, :group, :role, :index],
    [:admin, :group, :role, :create],
    [:admin, :group, :role, :delete],

    [:admin, :listing, :index],
    [:admin, :listing, :create],

    [:admin, :listing, :show],
    [:admin, :listing, :update],
    [:admin, :listing, :request_approval],
    [:admin, :listing, :refresh_expiry],
    [:admin, :listing, :expire],

    [:admin, :listing, :delete],
    [:admin, :listing, :approve],
    [:admin, :listing, :unapprove],

    [:admin, :listing, :role, :index],
    [:admin, :listing, :role, :create],
    [:admin, :listing, :role, :delete],

    [:admin, :listing, :applicant, :index],
    [:admin, :listing, :applicant, :export],

    [:admin, :listing, :tkn_listing, :show],
    [:admin, :listing, :tkn_listing, :create],
    [:admin, :listing, :tkn_listing, :update],
    [:admin, :listing, :tkn_listing, :spec],

    [:admin, :listing, :marketing_request, :show],
    [:admin, :listing, :marketing_request, :create],
  ])

  def is_valid!(action) do
    if not MapSet.member?(@actions, action) do
      raise InvalidAction, message: "#{inspect(action)} is an invalid action", action: action
    else
      true
    end
  end
end
