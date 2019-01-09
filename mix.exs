defmodule Volunteer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :volunteer,
      version: "1.1.0",
      elixir: "~> 1.7.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Volunteer.Application, []},
      extra_applications: [
        :crypto,
        :logger,
        :runtime_tools
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: elixirc_paths() ++ ["test/support"]
  defp elixirc_paths(_), do: elixirc_paths()
  defp elixirc_paths(), do: ["lib", "rel/tasks"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  def deps do
    [
      {:appsignal, "~> 1.9.0-beta.1"},
      {:bamboo, github: "thoughtbot/bamboo", branch: "master", override: true},
      {:bamboo_smtp, github: "fewlinesco/bamboo_smtp", branch: "master"},
      {:distillery, "~> 2.0"},
      {:ecto_sql, "~> 3.0"},
      {:faker, "~> 0.11", only: [:dev, :test]},
      {:gettext, "~> 0.13"},
      {:hammer, "~> 2.1.0"},
      {:jason, "~> 1.0"},
      {:jose, "~> 1.8"},
      {:phoenix, "~> 1.4.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:plug, "~> 1.7"},
      {:plug_cowboy, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:quantum, "~> 2.3"},
      {:recaptcha, github: "samueljseay/recaptcha", branch: "master"},
      {:semtex, github: "alizain/semtex", branch: "master"},
      {:sentry, "~> 7.0.3"},
      {:slugger, "~> 0.2"},
      {:timex, "~> 3.1"},
      {:ueberauth, "~> 0.4"},
      {:ueberauth_microsoft, "~> 0.3"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["test --trace"]
    ]
  end
end
