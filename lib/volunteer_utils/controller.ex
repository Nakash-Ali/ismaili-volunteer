defmodule VolunteerUtils.Controller do
  def booleanize(bool) when is_boolean(bool), do: bool
  def booleanize("true"), do: true
  def booleanize(_value), do: false

  def booleanize!(bool) when is_boolean(bool), do: bool
  def booleanize!("true"), do: true
  def booleanize!("false"), do: false
end
