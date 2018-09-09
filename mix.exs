defmodule Volunteer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :volunteer,
      version: "1.1.0",
      elixir: "~> 1.6",
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
  defp elixirc_paths(:prod), do: elixirc_paths() ++ ["rel/tasks"]
  defp elixirc_paths(_), do: elixirc_paths()
  defp elixirc_paths(), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  def deps do
    [
      {:phoenix, "~> 1.3"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.13"},
      {:cowboy, "~> 1.0"},
      {:edeliver, "~> 1.4", only: [:dev, :test]},
      {:distillery, ">= 1.5.3"},
      {:bamboo, github: "thoughtbot/bamboo", branch: "master", override: true},
      {:bamboo_smtp, github: "fewlinesco/bamboo_smtp", branch: "master"},
      {:recaptcha, github: "samueljseay/recaptcha", branch: "master"},
      {:sentry, "~> 6.2.1"},
      {:hammer, "~> 2.1.0"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:ueberauth, "~> 0.4"},
      {:ueberauth_microsoft, "~> 0.3"},
      {:timex, "~> 3.1"},
      {:apex, "~>1.2.0"},
      {:canada, github: "jarednorman/canada"},
      {:html_sanitize_ex, "~> 1.3.0-rc3"},
      {:floki, "~> 0.20.0"},
      {:slugger, "~> 0.2"},
      {:porcelain, "~> 2.0"},
      {:jose, "~> 1.8"}
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
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
