use Mix.Config

# General application configuration
config :volunteer,
  mock_sessions: true,
  use_ssl: false

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :volunteer, VolunteerWeb.Endpoint,
  http: [port: 4001],
  url: [host: "localhost"],
  secret_key_base: :crypto.strong_rand_bytes(128) |> Base.encode64() |> binary_part(0, 128),
  server: false

# Configure your database
config :volunteer, Volunteer.Repo,
  username: "postgres",
  password: System.get_env("DB_PASS") || "postgres",
  database: "postgres",
  hostname: "127.0.0.1",
  pool: Ecto.Adapters.SQL.Sandbox

# Print only warnings and errors during test
config :logger, level: :info

# Configure funcs
config :volunteer, Volunteer.Funcs,
  url: System.get_env("FUNCS_URL") || "http://localhost:8080",
  basic_auth_name: "ots",
  basic_auth_pass: "ots"

# Configure mailer
config :volunteer, VolunteerEmail.Mailer,
  adapter: VolunteerEmail.WrapperAdapter,
  wrapped_adapter: Bamboo.TestAdapter

# Configure Google's reCaptcha V2
# NOTE - the keys below are Google's publicly known test keys!
config :recaptcha,
  public_key: "6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI",
  secret: "6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe"
