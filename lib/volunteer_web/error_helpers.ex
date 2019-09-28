defmodule VolunteerWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  def is_submitted?(form) do
    form.source.action != nil
  end

  def has_errors?(form, field) do
    Keyword.has_key?(form.errors, field)
  end

  def error_tag(form, field) do
    error_tag(form, field, class: "invalid-feedback")
  end

  def error_tag(form, field, opts) when is_list(opts) do
    error_tag(form, field, fn error ->
      content_tag(:div, error, opts)
    end)
  end

  def error_tag(form, field, func) when is_function(func) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      error |> translate_error() |> func.()
    end)
  end

  def error_classes(form, field, opts \\ %{})

  def error_classes(form, field, opts) when is_list(opts) do
    error_classes(form, field, Enum.into(opts, %{}))
  end

  def error_classes(_form, _field, %{force: :none}) do
    []
  end

  def error_classes(_form, _field, %{force: :invalid}) do
    ["is-invalid"]
  end

  def error_classes(_form, _field, %{force: :valid}) do
    ["is-valid"]
  end

  def error_classes(form, field, _opts) do
    if is_submitted?(form) do
      case has_errors?(form, field) do
        true -> ["is-invalid"]
        false -> ["is-valid"]
      end
    else
      []
    end
  end

  def get_underscore_errors(%Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/3)
    |> get_underscore_errors([])
    |> Enum.dedup
  end

  def get_underscore_errors(raw_errors, accum) do
    get_underscore_errors(raw_errors, accum, nil)
  end

  def get_underscore_errors(nil, accum, _parent_key) do
    accum
  end

  def get_underscore_errors(raw_errors, accum, parent_key) when is_atom(parent_key) do
    get_underscore_errors(raw_errors, accum, Atom.to_string(parent_key))
  end

  def get_underscore_errors(raw_errors, accum, _parent_key) when is_map(raw_errors) do
    Enum.reduce(raw_errors, accum, fn {error_key, error_value}, accum ->
      get_underscore_errors(error_value, accum, error_key)
    end)
  end

  def get_underscore_errors(raw_errors, accum, parent_key) when is_list(raw_errors) do
    Enum.reduce(raw_errors, accum, fn error_value, accum ->
      get_underscore_errors(error_value, accum, parent_key)
    end)
  end

  def get_underscore_errors(error_value, accum, "_" <> _ = parent_key) when is_binary(error_value) do
    [{parent_key, error_value} | accum]
  end

  def get_underscore_errors(error_value, accum, _parent_key) when is_binary(error_value) do
    accum
  end

  def format_error(_changeset, _field, {msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
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
