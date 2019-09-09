defmodule VolunteerUtils.Changeset do
  def put_defaults(changeset, fields_with_defaults) do
    changeset_errors = Map.new(changeset.errors)

    Enum.reduce(fields_with_defaults, changeset, fn {field, default}, changeset ->
      if Map.has_key?(changeset_errors, field) do
        changeset
      else
        case Ecto.Changeset.fetch_field(changeset, field) do
          {:data, nil} ->
            Ecto.Changeset.put_change(changeset, field, default)

          :error ->
            Ecto.Changeset.put_change(changeset, field, default)

          _ ->
            changeset
        end
      end
    end)
  end

  def ignore_built_with_no_changes(changeset) do
    case changeset do
      %{changes: changes, data: %{__meta__: %{state: :built}}} = changeset when changes == %{} ->
        %{changeset | action: :ignore}

      changeset ->
        changeset
    end
  end
end
