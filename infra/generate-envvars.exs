Code.compiler_options(ignore_module_conflict: true)
Code.require_file("./infra/config.exs")

{[env: env], _, _} =
  System.argv()
  |> OptionParser.parse(switches: [env: :string])

envvars = VolunteerInfra.Config.envvars(env)

Enum.each(envvars, fn {key, value} ->
  IO.puts("export #{key}=\"#{value}\"")
end)
