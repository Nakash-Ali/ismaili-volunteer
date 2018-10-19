use Mix.Config

# General application configuration
config :volunteer,
  mock_sessions: true

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :volunteer, VolunteerWeb.Endpoint,
  http: [port: 4001],
  server: false

# Configure your database
config :volunteer, Volunteer.Repo,
  database: "postgres_test"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :volunteer, Volunteer.Repo, pool: Ecto.Adapters.SQL.Sandbox

# Configure mailer
config :volunteer, VolunteerEmail.Mailer, adapter: VolunteerEmail.WrapperAdapter, wrapped_adapter: Bamboo.TestAdapter
