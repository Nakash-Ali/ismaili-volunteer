defmodule VolunteerUtils.Choices do
  @blank_label_default "---"

  def make(choices, %{blank: true} = opts) do
    blank =
      Map.get(opts, :blank_label, @blank_label_default) |> blank_select_choice()

    blank ++ tupelize(choices)
  end

  def make(choices, %{blank: false}) do
    tupelize(choices)
  end

  def tupelize(choices) when is_list(choices) do
    Enum.map(choices, &(case &1 do
      %{id: id} = choice ->
        {VolunteerWeb.Presenters.Title.plain(choice), id}

      {value, label} when is_binary(value) and is_binary(label) ->
        {value, label}

      value_and_label when is_binary(value_and_label) ->
        value_and_label
    end))
  end

  def blank_select_choice(blank_label \\ @blank_label_default) do
    [{blank_label, ""}]
  end

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
