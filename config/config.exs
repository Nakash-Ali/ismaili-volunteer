# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

version =
  case File.read(".version") do
    {:ok, version} ->
      version |> String.trim()

    {:error, _} ->
      nil
  end

# Configure global constants
config :volunteer,
  version: version,
  global_title: "OpportunitiesToServe",
  global_email: "ots@iicanada.net",
  global_url: "https://ots.the.ismaili",
  global_attribution: "His Highness Prince Aga Khan Shia Imami Ismaili Council for Canada",
  global_parent_navbar_name: "IICanada",
  global_parent_navbar_url: "https://iicanada.org",
  allowed_auth_email_domains: ["iicanada.net"]

# General application configuration
config :volunteer,
  ecto_repos: [Volunteer.Repo],
  send_analytics: false,
  mock_sessions: false,
  use_ssl: false

# Configure social constants
config :volunteer, :social,
  title: "OpportunitiesToServe",
  description: "",
  url: "https://ots.the.ismaili",
  type: "website",
  image: "",
  facebook_app_id: ""

# Configures the endpoint
config :volunteer, VolunteerWeb.Endpoint,
  url: [host: "localhost"],
  static_at: "/static",
  static_url: [path: "/static"],
  secret_key_base: "RJhNnMngIMEJY605r0es6uPFY/TF/9u9CEgIp+ioEpML3Q1gE+vjxmZEJEOa7MtW",
  render_errors: [view: VolunteerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Volunteer.PubSub, adapter: Phoenix.PubSub.PG2],
  instrumenters: [Appsignal.Phoenix.Instrumenter]

# Configure your database
config :volunteer, Volunteer.Repo,
  migration_timestamps: [type: :timestamptz],
  username: "postgres",
  password: "postgres",
  database: "postgres",
  hostname: "127.0.0.1"

# Configure mailer
config :volunteer, VolunteerEmail.Mailer,
  adapter: VolunteerEmail.WrapperAdapter,
  wrapped_adapter: Bamboo.LocalAdapter

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure templating engines for Phoenix to use Appsignal
config :phoenix, :template_engines,
  eex: Appsignal.Phoenix.Template.EExEngine,
  exs: Appsignal.Phoenix.Template.ExsEngine

# Use Jason for JSON parsing in Bamboo
config :bamboo, :json_library, Jason

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
  environment_name: Mix.env(),
  enable_source_code_context: true,
  root_source_code_path: File.cwd!(),
  json_library: Jason,
  tags: %{
    env: "production"
  },
  included_environments: [:prod]

# Configure Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    microsoft:
      {Ueberauth.Strategy.Microsoft, [default_scope: "https://graph.microsoft.com/user.read"]}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Google's reCaptcha V2
# NOTE - the keys below are Google's publicly known test keys!
config :recaptcha,
  public_key: "6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI",
  secret: "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"

# Import scheduled jobs
import_config "scheduled_jobs.exs"

# Import AppSignal config
import_config "appsignal.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
