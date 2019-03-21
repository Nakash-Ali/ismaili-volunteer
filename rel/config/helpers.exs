defmodule VolunteerConfigHelpers do
  def secret_key_generator(length) do
    :crypto.strong_rand_bytes(length) |> Base.encode64() |> binary_part(0, length)
  end

  def from_env_or_do_alternative(key, alternate_func) do
    case System.get_env(key) do
      value when is_binary(value) and value not in [""] ->
        value

      _ ->
        alternate_func.()
    end
  end

  def from_env_or_default(key, default) do
    from_env_or_do_alternative(key, fn -> default end)
  end

  # This is important to make sure environment variables are not blank, which could cause security leaks!
  def require_env!(key) do
    from_env_or_do_alternative(key, fn -> raise "expected the #{key} environment variable to be set" end)
  end
end
