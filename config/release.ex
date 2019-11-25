import Config

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
### Run-time Configuration
###

# Configure the endpoint
config :volunteer, VolunteerWeb.Endpoint,
  http: [:inet6, port: require_env!.("PORT")],
  url: [host: require_env!.("ENDPOINT_URL_HOST"), port: 80],
  check_origin: require_env!.("ENDPOINT_URL_CHECK_ORIGIN") |> String.split(",")

# Configure database
config :volunteer, Volunteer.Repo,
  username: require_env!.("DB_USERNAME"),
  password: require_env!.("DB_PASSWORD"),
  database: require_env!.("DB_NAME"),
  socket: require_env!.("DB_HOST")

# Configure sentry's error logging
config :sentry,
  tags: %{
    gae_version: require_env!.("GAE_VERSION")
  }
