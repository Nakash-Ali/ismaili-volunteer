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
  secret_key_base: "RJhNnMngIMEJY605r0es6uPFY/TF/9u9CEgIp+ioEpML3Q1gE+vjxmZEJEOa7MtW",
  render_errors: [view: VolunteerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Volunteer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
