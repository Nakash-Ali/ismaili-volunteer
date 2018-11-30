[
  inputs: [
    "mix.exs",
    ".formatter.exs",
    "{lib,test,rel,priv,config}/**/*.{ex,exs}"
  ],
  import_deps: Mix.Dep.Lock.read() |> Map.keys(),
  locals_without_parens: []
]
