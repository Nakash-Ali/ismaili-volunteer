defmodule VolunteerUtils.Changeset do
  def put_defaults(changeset, fields_with_defaults) do
    Enum.reduce(fields_with_defaults, changeset, fn {field, default}, changeset ->
      case Ecto.Changeset.fetch_field(changeset, field) do
        {:data, nil} ->
          Ecto.Changeset.put_change(changeset, field, default)

        :error ->
          Ecto.Changeset.put_change(changeset, field, default)

        _ ->
          changeset
      end
    end)
  end
end
