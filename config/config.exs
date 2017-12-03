# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :volunteer,
  ecto_repos: [Volunteer.Repo]

# Configures the endpoint
config :volunteer, VolunteerWeb.Endpoint,
  url: [host: "localhost"],
  static_url: [path: "/static"],
  secret_key_base: "RJhNnMngIMEJY605r0es6uPFY/TF/9u9CEgIp+ioEpML3Q1gE+vjxmZEJEOa7MtW",
  render_errors: [view: VolunteerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Volunteer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configure your database
config :volunteer, Volunteer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "postgres",
  hostname: "127.0.0.1"

# Configure mailer
config :volunteer, VolunteerEmail.Mailer,
  adapter: Bamboo.LocalAdapter

# Configure hammer rate-limiter
config :hammer,
  backend: {
    Hammer.Backend.ETS,
    [
      expiry_ms: 60_000 * 60 * 4,
      cleanup_interval_ms: 60_000 * 10
    ]
  }

# Configure Sentry's error logging
config :sentry,
  environment_name: Mix.env,
  enable_source_code_context: true,
  root_source_code_path: File.cwd!,
  tags: %{
    env: "production"
  },
  included_environments: [:prod]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Google's reCaptcha V2
# NOTE - the keys below are Google's publicly known test keys!
config :recaptcha,
  public_key: {:system, "6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI"},
  secret: {:system, "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"