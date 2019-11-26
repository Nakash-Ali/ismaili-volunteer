Code.compiler_options(ignore_module_conflict: true)
Code.require_file("./infra/config.exs")

{[env: env, out: out], _, _} =
  System.argv()
  |> OptionParser.parse(switches: [env: :string, out: :string])

context =
  System.get_env()
  |> IO.inspect

secrets =
  VolunteerInfra.Config.secrets(context, env)

envvars =
  VolunteerInfra.Config.envvars(context, env)
  |> Map.drop(["GCLOUD_PROJECT"])

assigns = secrets ++ [
  envvars: envvars,
  skip_deps_folder: (if context["CI"] == "true", do: false, else: true),
  skip_build_folder: (if context["CI"] == "true", do: false, else: true),
]

compiled =
  "./infra/app.yaml"
  |> EEx.eval_file(assigns, [trim: true])

File.write!(out, compiled)
