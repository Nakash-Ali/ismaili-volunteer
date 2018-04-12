defmodule VolunteerWeb.FormView do
  use VolunteerWeb, :view

  defp input_classes(form, field, others \\ []) do
    is_submitted?(form)
    |> input_classes_for_state(form, field)
    |> Enum.concat(others)
    |> Enum.join(" ")
  end

  defp input_classes_for_state(_submitted = true, form, field) do
    case has_errors?(form, field) do
      true -> ["is-invalid"]
      false -> ["is-valid"]
    end
  end

  defp input_classes_for_state(_submitted = false, form, field) do
    []
  end
end
