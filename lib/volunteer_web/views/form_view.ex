defmodule VolunteerWeb.FormView do
  use VolunteerWeb, :view

  @wrapper "_wrapper.html"

  def render_nested([], _opts) do
    nil
  end

  def render_nested([template], opts) do
    render(template, opts)
  end

  def render_nested([template | rem_templates], opts) do
    render_nested(rem_templates, opts ++ [do: render(template, opts)])
  end

  def render_field(template, opts) when is_list(opts) do
    render_nested([template, @wrapper], opts)
  end

  def render_field(template, with_template, opts) when is_list(opts) do
    render_nested([template, with_template, @wrapper], opts)
  end

  def is_submitted?(form) do
    form.source.action != nil
  end

  def input_classes(form, field, others) do
    is_submitted?(form)
    |> input_classes_for_state(form, field)
    |> Enum.concat(others)
    |> Enum.join(" ")
  end

  def input_classes_for_state(_submitted = true, form, field) do
    case ErrorHelpers.has_errors?(form, field) do
      true -> ["is-invalid"]
      false -> ["is-valid"]
    end
  end

  def input_classes_for_state(_submitted = false, _form, _field) do
    []
  end

  defp textarea_hidden_input(form, field) do
    escaped_value =
      input_value(form, field)
      |> VolunteerWeb.HTMLInput.deserialize_for_edit()

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

  def checkbox_list_value(form, field, to_check) do
    if to_check in (input_value(form, field) || []) do
      to_check
    else
      ""
    end
  end
end
