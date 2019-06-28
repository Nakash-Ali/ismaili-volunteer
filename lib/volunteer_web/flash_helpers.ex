defmodule VolunteerWeb.FlashHelpers do
  def put_paragraph_flash(conn, key, message) do
    Phoenix.Controller.put_flash(conn, key, {:paragraph, message})
  end

  def put_structured_flash(conn, key, message) do
    Phoenix.Controller.put_flash(conn, key, {:structured, message})
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
