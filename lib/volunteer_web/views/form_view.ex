defmodule VolunteerWeb.FormView do
  use VolunteerWeb, :view
  
  defp input_classes(form, field, others \\ []) do
    is_submitted?(form)
    |> input_classes_for_state(form, field)
    |> Enum.concat(others)
    |> Enum.concat(['form-control'])
    |> Enum.join(" ")
  end
  
  defp input_classes_for_state(_submitted = true, form, field) do
    case has_errors?(form, field) do
      true -> ['is-invalid']
      false -> ['is-valid']
    end
  end
  
  defp input_classes_for_state(_submitted = false, form, field) do
    []
  end
  
  defp toggle_id(form, field) do
    input_id(form, field) <> "-toggle"
  end
  
  defp toggle_is_checked(form, field) do
    val = input_value(form, field)
    val == nil || val == ""
  end
end
