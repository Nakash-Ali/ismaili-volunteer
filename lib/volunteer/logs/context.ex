defmodule Volunteer.Logs.Context do
  def serialize(%{__struct__: module} = struct) do
    serialize(struct, :all)
  end

  def serialize(%{__struct__: module} = struct, :all) do
    struct
    |> Map.take(module.__schema__(:fields))
  end
end
