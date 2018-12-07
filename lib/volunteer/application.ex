defmodule Volunteer.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Volunteer.Repo, []),
      # Start the scheduler
      worker(Volunteer.Scheduler, []),
      # Start the generators
      worker(VolunteerWeb.Services.ListingSocialImageGenerator, []),
      worker(VolunteerWeb.Services.TKNAssignmentSpecGenerator, []),
      # Start the endpoint when the application starts
      supervisor(VolunteerWeb.Endpoint, [])
    ]

    # Capture all errors, that aren't caught by Plug
    {:ok, _} = Logger.add_backend(Sentry.LoggerBackend)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Volunteer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    VolunteerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
