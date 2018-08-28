defmodule VolunteerWeb.FormView do
  use VolunteerWeb, :view

  def is_submitted?(form) do
    form.source.action != nil
  end

  defp input_classes(form, field, others) do
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

  defp input_classes_for_state(_submitted = false, _form, _field) do
    []
  end

  defp textarea_hidden_input(form, field) do
    escaped_value =
      input_value(form, field)
      |> html_escape()
      |> safe_to_string

    hidden_input(form, field, value: escaped_value)
  end

  def label_classes(assigns, others \\ []) do
    others
    |> Enum.concat(label_classes_for_required(assigns))
    |> Enum.join(" ")
  end

  def label_classes_for_required(%{required: true}) do
    ["required-label"]
  end

  def label_classes_for_required(_) do
    []
  end
end
