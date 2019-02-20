defmodule Volunteer.NameNormalizer do
  def to_titlecase(nil) do
    nil
  end

  def to_titlecase(str) do
    str
    |> String.split(" ")
    |> Enum.map(fn str ->
      if String.contains?(str, "-") do
        part_with_dashes_to_titlecase(str)
      else
        part_to_titlecase(str)
      end
    end)
    |> Enum.join(" ")
  end

  defp part_to_titlecase(str) do
    String.capitalize(str)
  end

  defp part_with_dashes_to_titlecase(str) do
    str
    |> String.split("-")
    |> case do
      [one, two] ->
        [String.capitalize(one), String.capitalize(two)]

      [one, middle, two] ->
        [String.capitalize(one), String.downcase(middle), String.capitalize(two)]
    end
    |> Enum.join("-")
  end
end
