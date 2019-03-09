{[env: env, out: out], _, _} =
  System.argv()
  |> OptionParser.parse(switches: [env: :string, out: :string])

secrets =
  "./infra/#{env}.appengine-secrets.json"
  |> File.read!()
  |> Jason.decode!(keys: :atoms)
  |> Enum.into([])

compiled =
  EEx.eval_file("./infra/app.yaml", secrets)

File.write!(out, compiled)
