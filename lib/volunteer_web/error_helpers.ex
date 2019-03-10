defmodule VolunteerWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  def error_tag(form, field) do
    error_tag(form, field, class: "invalid-feedback")
  end

  def error_tag(form, field, class: class) do
    error_tag(form, field, fn error ->
      content_tag(:div, error, class: class)
    end)
  end

  def error_tag(form, field, func) when is_function(func) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      error |> translate_error() |> func.()
    end)
  end

  def has_errors?(form, field) do
    Keyword.has_key?(form.errors, field)
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    # Because error messages were defined within Ecto, we must
    # call the Gettext module passing our Gettext backend. We
    # also use the "errors" domain as translations are placed
    # in the errors.po file.
    # Ecto will pass the :count keyword if the error message is
    # meant to be pluralized.
    # On your own code and templates, depending on whether you
    # need the message to be pluralized or not, this could be
    # written simply as:
    #
    #     dngettext "errors", "1 file", "%{count} files", count
    #     dgettext "errors", "is invalid"
    #
    if count = opts[:count] do
      Gettext.dngettext(VolunteerWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(VolunteerWeb.Gettext, "errors", msg, opts)
    end
  end
end