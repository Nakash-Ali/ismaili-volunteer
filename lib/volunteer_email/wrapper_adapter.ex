defmodule VolunteerEmail.WrapperAdapter do
  @behaviour Bamboo.Adapter

  def deliver(email, config) do
    email =
      VolunteerEmail.Transformers.ensure_unique_addresses(email)

    get_wrapped_adapter(config).deliver(email, config)
  end

  def handle_config(config) do
    get_wrapped_adapter(config).handle_config(config)
  end

  # Since the `wrapped_adapter` is inside the config object, and the config
  # object isn't passed to this function, we can't reliably use attachments
  def supports_attachments? do
    false
  end

  def get_wrapped_adapter(config) do
    case config.wrapped_adapter do
      adapter when is_atom(adapter) -> adapter
      "send_grid" -> Bamboo.SendGridAdapter
      _ -> Bamboo.LocalAdapter
    end
  end
end
