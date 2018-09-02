defmodule Volunteer.ReleaseTasks.Database do
  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto
  ]

  @otp_app :volunteer

  def repos do
    Application.get_env(@otp_app, :ecto_repos, [])
  end

  def run do
    me = @otp_app

    # # Load the code for app, but don't start it
    IO.puts("Loading #{me}..")

    case Application.load(me) do
      :ok -> :ok
      {:error, {:already_loaded, :volunteer}} -> :ok
    end

    # Start apps necessary for executing migrations
    IO.puts("Starting dependencies..")
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for app
    IO.puts("Starting repos..")
    Enum.each(repos(), & &1.start_link(pool_size: 1))

    # Run migrations
    IO.puts("Running migrations..")
    Enum.each(repos(), &run_migrations_for/1)

    # Run seed script
    Enum.each(repos(), &run_seeds_for/1)

    # Signal shutdown
    IO.puts("Success!")
    :init.stop()
  end

  def run_migrations_for(repo) do
    app = Keyword.get(repo.config, :otp_app)
    IO.puts("Running migrations for #{app}")
    Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
  end

  def run_seeds_for(repo) do
    seeds_scripts(repo)
    |> Path.wildcard()
    |> Enum.sort()
    |> Enum.each(&run_seed_script/1)
  end

  def run_seed_script(script) do
    IO.puts("Running seed script #{script}..")
    Code.eval_file(script)
  end

  def migrations_path(repo), do: priv_path_for(repo, "migrations")

  def seeds_scripts(repo), do: priv_path_for(repo, "seeds/*.exs")

  def priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)
    repo_underscore = repo |> Module.split() |> List.last() |> Macro.underscore()
    Path.join([priv_dir(app), repo_underscore, filename])
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"
end
