Code.require_file("./infra/Config.exs")

{[env: env, out: out], _, _} =
  System.argv()
  |> OptionParser.parse(switches: [env: :string, out: :string])

envvars = VolunteerInfra.Config.envvars(env)
secrets = VolunteerInfra.Config.secrets(env)

compiled =
  "./infra/app.yaml"
  |> EEx.eval_file([envvars: envvars] ++ secrets, [trim: true])

IO.puts("")
IO.puts(compiled)
IO.puts("")

File.write!(out, compiled)
