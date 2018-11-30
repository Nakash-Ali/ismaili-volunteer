[
  inputs: [
    "mix.exs",
    ".formatter.exs",
    "{lib,test,rel,priv,config}/**/*.{ex,exs}"
  ],
  import_deps: Volunteer.Mixfile.deps() |> Enum.map(fn dep_tup -> elem(dep_tup, 0) end),
  locals_without_parens: []
]
