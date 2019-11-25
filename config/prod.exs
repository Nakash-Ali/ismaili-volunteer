use Mix.Config

require_env! =
  fn key ->
    case System.get_env(key) do
      value when is_binary(value) and value not in [""] ->
        value

      _ ->
        raise "expected the #{key} environment variable to be set"
    end
  end

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
  secret_key_base: :crypto.strong_rand_bytes(64) |> Base.encode64() |> binary_part(0, 64),
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
  wrapped_adapter: require_env!.("MAILER_WRAPPED_ADAPTER"),
  api_key: System.get_env("MAILER_API_KEY", nil)

# Configure Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    microsoft:
      {
        Ueberauth.Strategy.Microsoft,
        [
          default_scope: "https://graph.microsoft.com/user.read",
          callback_url: System.get_env("MICROSOFT_OAUTH_CALLBACK_URL", nil)
        ]
      }
  ]

# Configure Azure AD v2.0 OAuth2 Flow
config :ueberauth, Ueberauth.Strategy.Microsoft.OAuth,
  client_id: require_env!.("MICROSOFT_OAUTH_CLIENT_ID"),
  client_secret: require_env!.("MICROSOFT_OAUTH_CLIENT_SECRET")

# Configure sentry's error logging
config :sentry,
  dsn: require_env!.("SENTRY_DSN"),
  included_environments: [(require_env!.("SENTRY_ENVIRONMENT_NAME") |> String.to_atom())],
  environment_name: (require_env!.("SENTRY_ENVIRONMENT_NAME") |> String.to_atom())

# Configure Google's reCaptcha V2
config :recaptcha,
  public_key: require_env!.("RECAPTCHA_PUBLIC_KEY"),
  secret: require_env!.("RECAPTCHA_SECRET")

# Configure Canny
config :volunteer, :canny,
  private_key: require_env!.("CANNY_PRIVATE_KEY")

# Configure Filestack
config :volunteer, :filestack,
  api_key: require_env!.("FILESTACK_API_KEY"),
  app_secret: require_env!.("FILESTACK_APP_SECRET")

# Configure AppSignal
config :appsignal, :config, active: true
