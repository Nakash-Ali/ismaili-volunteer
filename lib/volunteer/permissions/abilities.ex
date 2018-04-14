defmodule Volunteer.Permissions.Abilities do
  alias Volunteer.Accounts.User
  alias Volunteer.Apply.Listing

  defmodule Shared do
    def make_all_actions(schema_actions, common_actions) do
      schema_actions
      |> Enum.map(fn {key, value} ->
        {key, value ++ common_actions}
      end)
      |> Enum.into(%{})
    end

    def flatten_all_actions(all_actions) do
      all_actions
      |> Map.values()
      |> List.flatten()
      |> Enum.uniq()
    end
  end

  defmodule Public do
    @common_actions [
      # show list of all records
      :index,
      # show a single record
      :show
    ]

    @schema_actions %{
      Listing => []
    }

    @all_actions Shared.make_all_actions(@schema_actions, @common_actions)
    @all_actions_flat Shared.flatten_all_actions(@all_actions)

    # Sanity checks

    def can?(_user, action, _subject)
        when action not in @all_actions_flat do
      false
    end

    # Listings

    def can?(_user, action, Listing)
        when action in [:index, :show] do
      true
    end

    # Deny everything else

    def can?(_user, _action, _subject) do
      false
    end
  end

  defmodule Admin do
    @common_actions [
      # show list of all records
      :index,
      # show creation form
      :new,
      # actually create the record
      :create,
      # show a single record
      :show,
      # show the editing form
      :edit,
      # actually update a record
      :update,
      # actually delete a record
      :delete
    ]

    @schema_actions %{
      Listing => [
        :index_all,
        :approve,
        :unapprove
      ]
    }

    @all_actions Shared.make_all_actions(@schema_actions, @common_actions)
    @all_actions_flat Shared.flatten_all_actions(@all_actions)

    # Sanity checks

    def can?(_user, action, _subject)
        when action not in @all_actions_flat do
      false
    end

    # Temporary super-user permissions

    def can?(%User{primary_email: primary_email}, _action, _subject)
        when primary_email in ["alizain.feerasta@iicanada.net"] do
      true
    end

    # Listings

    def can?(%User{}, action, Listing)
        when action in [:index, :new, :create] do
      true
    end

    def can?(%User{id: user_id}, action, %Listing{created_by_id: user_id})
        when action in [:show, :edit, :update, :delete] do
      true
    end

    # Deny everything else

    def can?(_user, _action, _subject) do
      false
    end
  end
end
