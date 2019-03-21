use Mix.Config

System.get_env("RELEASE_ROOT_DIR")
|> Path.join("/etc/helpers.exs")
|> Code.require_file()

###
### Run-time Configuration
###

# Configure the endpoint
config :volunteer, VolunteerWeb.Endpoint,
  http: [:inet6, port: VolunteerConfigHelpers.require_env!("PORT")],
  url: [host: VolunteerConfigHelpers.require_env!("ENDPOINT_URL_HOST"), port: 80],
  check_origin: (VolunteerConfigHelpers.require_env!("ENDPOINT_URL_CHECK_ORIGIN") |> String.split(","))

# Configure database
config :volunteer, Volunteer.Repo,
  username: VolunteerConfigHelpers.require_env!("DB_USERNAME"),
  password: VolunteerConfigHelpers.require_env!("DB_PASSWORD"),
  database: VolunteerConfigHelpers.require_env!("DB_NAME"),
  socket: VolunteerConfigHelpers.require_env!("DB_HOST")

# Configure mailer
config :volunteer, VolunteerEmail.Mailer,
  api_key: VolunteerConfigHelpers.from_env_or_default("MAILER_API_KEY", nil)

# Configure sentry's error logging
config :sentry,
  dsn: VolunteerConfigHelpers.require_env!("SENTRY_DSN"),
  included_environments: [(VolunteerConfigHelpers.require_env!("SENTRY_ENVIRONMENT_NAME") |> String.to_atom())],
  environment_name: (VolunteerConfigHelpers.require_env!("SENTRY_ENVIRONMENT_NAME") |> String.to_atom()),
  tags: %{
    gae_version: VolunteerConfigHelpers.require_env!("GAE_VERSION")
  }

# Configure Google's reCaptcha V2
config :recaptcha,
  public_key: VolunteerConfigHelpers.require_env!("RECAPTCHA_PUBLIC_KEY"),
  secret: VolunteerConfigHelpers.require_env!("RECAPTCHA_SECRET")

# Configure Canny
config :volunteer, :canny,
  private_key: VolunteerConfigHelpers.require_env!("CANNY_PRIVATE_KEY")

# Configure Azure AD v2.0 OAuth2 Flow
config :ueberauth, Ueberauth.Strategy.Microsoft.OAuth,
  client_id: VolunteerConfigHelpers.require_env!("MICROSOFT_OAUTH_CLIENT_ID"),
  client_secret: VolunteerConfigHelpers.require_env!("MICROSOFT_OAUTH_CLIENT_SECRET")
