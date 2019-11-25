Code.compiler_options(ignore_module_conflict: true)
Code.require_file("./infra/config.exs")

{[env: env, out: out], _, _} =
  System.argv()
  |> OptionParser.parse(switches: [env: :string, out: :string])

envvars = VolunteerInfra.Config.envvars(env)
secrets = VolunteerInfra.Config.secrets(env)

compiled =
  "./infra/app.yaml"
  |> EEx.eval_file([envvars: envvars] ++ secrets, [trim: true])

File.write!(out, compiled)
