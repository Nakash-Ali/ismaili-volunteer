defmodule VolunteerEmail.WrapperAdapter do
  @behaviour Bamboo.Adapter

  def deliver(email, config) do
    email
    |> VolunteerEmail.Transformers.ensure_unique_addresses()
    |> config.wrapped_adapter.deliver(config)
  end

  def handle_config(config) do
    config.wrapped_adapter.handle_config(config)
  end
end
