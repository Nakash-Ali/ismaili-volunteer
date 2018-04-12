[
  inputs: [
    "{mix,.formatter}.exs",
    "{config,lib,test}/**/*.{ex,exs}"
  ],
  import_deps: Volunteer.Mixfile.deps |> Enum.map(fn dep_tup -> elem(dep_tup, 0) end)
]
