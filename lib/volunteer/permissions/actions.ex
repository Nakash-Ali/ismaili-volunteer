defmodule Volunteer.Permissions.Actions do
  defmodule Type do
    use Ecto.Type
    def type, do: {:array, :string}

    def cast(action) when is_list(action) do
      if Enum.all?(action, &is_atom/1) do
        {:ok, action}
      else
        :error
      end
    end

    def cast(_), do: :error

    def load(action) when is_list(action) do
      {:ok, Enum.map(action, &String.to_existing_atom/1)}
    end

    def dump(action) when is_list(action) do
      if Enum.all?(action, &is_atom/1) do
        {:ok, Enum.map(action, &Atom.to_string/1)}
      else
        :error
      end
    end

    def dump(_), do: :error
  end

  defmodule InvalidAction do
    defexception [:message, :action]
  end

  @actions MapSet.new([
    [:admin, :index],

    [:admin, :system, :index],
    [:admin, :system, :feedback_from_applicants],
    [:admin, :system, :feedback_from_organizers],
    [:admin, :system, :env],
    [:admin, :system, :app],
    [:admin, :system, :endpoint],
    [:admin, :system, :req_headers],
    [:admin, :system, :spoof],

    [:admin, :user, :index],

    [:admin, :region, :index],
    [:admin, :region, :show],

    [:admin, :region, :role, :index],
    [:admin, :region, :role, :new],
    [:admin, :region, :role, :create],
    [:admin, :region, :role, :delete],

    [:admin, :group, :index],
    [:admin, :group, :show],

    [:admin, :group, :role, :index],
    [:admin, :group, :role, :new],
    [:admin, :group, :role, :create],
    [:admin, :group, :role, :delete],

    [:admin, :listing, :index],
    [:admin, :listing, :new],
    [:admin, :listing, :create],

    [:admin, :listing, :show],
    [:admin, :listing, :edit],
    [:admin, :listing, :update],

    [:admin, :listing, :public, :approve],
    [:admin, :listing, :public, :unapprove],

    [:admin, :listing, :public, :request_approval],
    [:admin, :listing, :public, :refresh],
    [:admin, :listing, :public, :expire],
    [:admin, :listing, :public, :expiry_reminder],
    [:admin, :listing, :public, :reset],

    [:admin, :listing, :role, :index],
    [:admin, :listing, :role, :new],
    [:admin, :listing, :role, :create],
    [:admin, :listing, :role, :delete],

    [:admin, :listing, :applicant, :index],
    [:admin, :listing, :applicant, :export],

    [:admin, :listing, :tkn, :show],
    [:admin, :listing, :tkn, :edit],
    [:admin, :listing, :tkn, :update],
    [:admin, :listing, :tkn, :spec],

    [:admin, :listing, :marketing_request, :new],
    [:admin, :listing, :marketing_request, :create],
  ])

  def actions do
    @actions
  end

  def actions_list do
    MapSet.to_list(@actions)
  end

  def is_valid!(action) do
    if not MapSet.member?(@actions, action) do
      raise InvalidAction, message: "#{inspect(action)} is an invalid action", action: action
    else
      true
    end
  end
end
