Code.compiler_options(ignore_module_conflict: true)
Code.require_file("./infra/config.exs")

{[env: env, out: out], _, _} =
  System.argv()
  |> OptionParser.parse(switches: [env: :string, out: :string])

context =
  System.get_env()

secrets =
  VolunteerInfra.Config.secrets(context, env)

envvars =
  VolunteerInfra.Config.envvars(context, env)
  |> Map.drop(["GCLOUD_PROJECT"])

assigns = [envvars: envvars] ++ secrets

compiled =
  "./infra/app.yaml"
  |> EEx.eval_file(assigns, [trim: true])

File.write!(out, compiled)
