defmodule VolunteerWeb.FlashHelpers do
  def put_underscore_errors(conn, errors) do
    Enum.reduce(errors, conn, fn {_error_key, error_value}, conn ->
      put_flash(conn, :error, :paragraph, error_value)
    end)
  end

  def put_paragraph_flash(conn, error_type, message) do
    put_flash(conn, error_type, :paragraph, message)
  end

  def put_structured_flash(conn, error_type, message) do
    put_flash(conn, error_type, :structured, message)
  end

  def put_flash(conn, error_type, message_type, message) do
    Phoenix.Controller.put_flash(conn, error_type, {message_type, message})
  end

  def configs() do
    [
      %{
        type: :error,
        container_class: "alert-danger",
        icon_class: "fas fa-exclamation-triangle"
      },
      %{
        type: :warning,
        container_class: "alert-warning",
        icon_class: "fas fa-exclamation-triangle"
      },
      %{
        type: :success,
        container_class: "alert-success",
        icon_class: "far fa-check-circle"
      },
      %{
        type: :info,
        container_class: "alert-info",
        icon_class: "far fa-info-circle"
      }
    ]
  end
end
