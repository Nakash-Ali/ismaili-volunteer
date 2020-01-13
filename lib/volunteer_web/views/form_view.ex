defmodule VolunteerWeb.FormView do
  use VolunteerWeb, :view

  @wrapper "with_wrapper.html"

  def render_field(field_template, opts) when is_list(opts) do
    render_nested([field_template, @wrapper], opts)
  end

  def render_field(field_template, with_template, opts) when is_list(opts) do
    render_nested([field_template, with_template, @wrapper], opts)
  end

  def form_text(opts, content \\ nil) do
    content_tag(:p, content, opts ++ [class: HTMLHelpers.io_join(["form-text", "small", "mt-2q", "mb-0", "text-muted"])])
  end

  def help_text(%{help_text: help_text}) do
    form_text([], help_text)
  end

  def help_text(_assigns) do
    nil
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
