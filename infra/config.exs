defmodule VolunteerInfra.Config do
  def envvars(env) do
    env
    |> secrets
    |> env_compile
  end

  def secrets(env) do
    "./infra/config.#{env}.secrets.exs"
    |> Code.require_file()

    System.get_env()
    |> VolunteerInfra.Secrets.configure()
    |> Enum.into([])
  end

  defp env_compile(key_values) do
    key_values
    |> env_from_config()
    |> env_flatten()
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Enum.into(%{})
  end

  defp env_from_config(key_values, prefixes \\ []) do
    Enum.map(key_values, fn
      {key, value} when is_map(value) ->
        {env_from_config_key(key, prefixes), env_from_config(value, prefixes ++ [key])}

      {key, value} ->
        {env_from_config_key(key, prefixes), value}
    end)
  end

  defp env_from_config_key(key, prefixes) when is_list(prefixes) do
    (prefixes ++ [key])
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.upcase/1)
    |> Enum.join("_")
  end

  defp env_flatten(key_values) do
    Enum.reduce(key_values, [], fn
      {_key, value}, acc when is_list(value) ->
        env_flatten(value) ++ acc

      pair, acc ->
        [ pair | acc ]
    end)
  end
end
