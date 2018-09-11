defmodule VolunteerWeb.FlashView do
  use VolunteerWeb, :view

  def flash_configs() do
    [
      %{
        flash_type: :error,
        container_class: "alert-danger",
        icon_class: "fas fa-exclamation-triangle"
      },
      %{
        flash_type: :success,
        container_class: "alert-success",
        icon_class: "far fa-check-circle"
      },
      %{
        flash_type: :info,
        container_class: "alert-info",
        icon_class: "far fa-info-circle"
      },
    ]
  end
end
