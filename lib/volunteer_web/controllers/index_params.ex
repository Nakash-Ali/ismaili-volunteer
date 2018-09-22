defmodule VolunteerWeb.IndexParams do
  defmodule IndexFilters do
    @types %{
      region_id: :integer,
    }

    @defaults %{
      region_id: nil,
    }

    def changeset(params, region_choice_tuples \\ [])
    def changeset(nil, _region_choice_tuples), do: changeset(%{})
    def changeset(params, region_choice_tuples) do
      region_id_choices =
        Enum.map(region_choice_tuples, &elem(&1, 1))

      {@defaults, @types}
      |> Ecto.Changeset.cast(params, Map.keys(@types))
      |> Ecto.Changeset.validate_inclusion(:region_id, region_id_choices)
    end

    def changes_and_data(params, region_choice_tuples \\ []) do
      case changeset(params, region_choice_tuples) do
        %{valid?: true} = changes ->
          {changes, Ecto.Changeset.apply_changes(changes)}
        %{valid?: false, data: data} = changes ->
          {changes, data}
      end
    end
  end
end
