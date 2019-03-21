use Mix.Config

Code.require_file("./rel/config/helpers.exs")

###
### Compile-time Configuration
###

# General application configuration
config :volunteer,
  send_analytics: true

# Configure the endpoint
config :volunteer, VolunteerWeb.Endpoint,
  root: ".",
  cache_static_manifest: "priv/static/cache_manifest.json",
  secret_key_base: VolunteerConfigHelpers.secret_key_generator(64),
  server: true,
  code_reloader: false

# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
config :phoenix, :serve_endpoints, true

# Do not print debug messages in production
config :logger, level: :info

# Configure database
config :volunteer, Volunteer.Repo,
  log: :warn,
  timeout: 7200_000,
  pool_size: 20

# Configure mailer
config :volunteer, VolunteerEmail.Mailer,
  adapter: VolunteerEmail.WrapperAdapter,
  wrapped_adapter: VolunteerConfigHelpers.require_env!("MAILER_WRAPPED_ADAPTER")

# Configure Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    microsoft:
      {
        Ueberauth.Strategy.Microsoft,
        [
          default_scope: "https://graph.microsoft.com/user.read",
          callback_url: VolunteerConfigHelpers.from_env_or_default("MICROSOFT_OAUTH_CALLBACK_URL", nil)
        ]
      }
  ]

# Configure AppSignal
config :appsignal, :config, active: true
