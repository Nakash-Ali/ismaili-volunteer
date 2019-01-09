use Mix.Config

config :volunteer, Volunteer.Scheduler,
  jobs: [
    # Every 6 hours
    {"0 */6 * * *", {Volunteer.Listings.ExpiryReminder, :get_and_notify_all, []}}
  ]
