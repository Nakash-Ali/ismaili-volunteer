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

    [:admin, :listing, :home, :show],

    [:admin, :listing, :public, :show],
    [:admin, :listing, :public, :approve],
    [:admin, :listing, :public, :unapprove],
    [:admin, :listing, :public, :request_approval],
    [:admin, :listing, :public, :refresh],
    [:admin, :listing, :public, :expire],
    [:admin, :listing, :public, :reset],

    [:admin, :listing, :role, :index],
    [:admin, :listing, :role, :create],
    [:admin, :listing, :role, :delete],

    [:admin, :listing, :applicant, :index],
    [:admin, :listing, :applicant, :export],

    [:admin, :listing, :tkn, :show],
    [:admin, :listing, :tkn, :update],
    [:admin, :listing, :tkn, :spec],

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
