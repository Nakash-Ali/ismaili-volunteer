Code.compiler_options(ignore_module_conflict: true)
Code.require_file("./infra/config.exs")

{[env: env, out: out], _, _} =
  System.argv()
  |> OptionParser.parse(switches: [env: :string, out: :string])

secrets =
  VolunteerInfra.Config.secrets(env)

envvars =
  VolunteerInfra.Config.envvars(env)
  |> Map.drop(["GCLOUD_PROJECT"])
  |> IO.inspect

compiled =
  "./infra/app.yaml"
  |> EEx.eval_file([envvars: envvars] ++ secrets, [trim: true])

File.write!(out, compiled)
