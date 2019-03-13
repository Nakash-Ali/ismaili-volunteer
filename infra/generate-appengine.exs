defmodule EnvGenerator do
  def compile(key_values) do
    key_values
    |> from_config()
    |> flatten()
    |> Enum.into(%{})
  end

  def from_config(key_values, prefixes \\ []) do
    Enum.map(key_values, fn
      {key, value} when is_map(value) ->
        {from_config_key(key, prefixes), from_config(value, prefixes ++ [key])}

      {key, value} ->
        {from_config_key(key, prefixes), value}
    end)
  end

  def from_config_key(key, prefixes) when is_list(prefixes) do
    (prefixes ++ [key])
    |> Enum.map(&to_string/1)
    |> Enum.map(&String.upcase/1)
    |> Enum.join("_")
  end

  def flatten(key_values) do
    Enum.reduce(key_values, [], fn
      {_key, value}, acc when is_list(value) ->
        flatten(value) ++ acc

      pair, acc ->
        [ pair | acc ]
    end)
  end
end


{[env: env, out: out], _, _} =
  System.argv()
  |> OptionParser.parse(switches: [env: :string, out: :string])

secrets =
  "./infra/#{env}.appengine-secrets.json"
  |> File.read!()
  |> Jason.decode!(keys: :atoms)
  |> Enum.into([])

env =
  secrets
  |> EnvGenerator.compile()

compiled =
  "./infra/app.yaml"
  |> EEx.eval_file([env: env] ++ secrets, [trim: true])

IO.puts("")
IO.puts(compiled)
IO.puts("")

File.write!(out, compiled)
