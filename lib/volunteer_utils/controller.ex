defmodule VolunteerUtils.Controller do
  def blank_select_choice(blank_label \\ "---") do
    [{blank_label, ""}]
  end

  def booleanize(bool) when is_boolean(bool), do: bool
  def booleanize("true"), do: true
  def booleanize(_value), do: false

  def booleanize!(bool) when is_boolean(bool), do: bool
  def booleanize!("true"), do: true
  def booleanize!("false"), do: false

  def transpose_choices(choices) do
    Enum.map(choices, fn {key, value} -> {value, key} end)
  end
end
