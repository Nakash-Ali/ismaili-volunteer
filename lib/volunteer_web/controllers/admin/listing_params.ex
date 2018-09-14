defmodule VolunteerWeb.Admin.ListingParams do
  defmodule IndexFilters do
    @types %{
      approved: :boolean,
      unapproved: :boolean,
      expired: :boolean,
    }

    @defaults %{
      approved: true,
      unapproved: true,
      expired: false
    }

    def changeset(nil), do: changeset(%{})
    def changeset(params) do
      {@defaults, @types}
      |> Ecto.Changeset.cast(params, Map.keys(@types))
    end

    def changes_and_data(params) do
      case changeset(params) do
        %{valid?: true} = changes ->
          {changes, Ecto.Changeset.apply_changes(changes)}
        %{valid?: false, data: data} = changes ->
          {changes, data}
      end
    end
  end
end
