defmodule VolunteerUtils.Choices do
  def values(choices) do
    Enum.map(choices, fn {value, _label} -> value end)
  end

  def label(choices, value) do
    choices
    |> Enum.find(fn
      {^value, _label} -> true
      _ -> false
    end)
    |> case do
      {_value, label} ->
        label

      nil ->
        ""

      _ ->
        raise "invalid value of \"#{value}\""
    end
  end

  def labels(choices, values) when is_list(values) do
    choices = Enum.into(choices, %{})
    Enum.map(values, &Map.fetch!(choices, &1))
  end

  def transpose(choices) do
    Enum.map(choices, fn {value, label} -> {label, value} end)
  end
end
