# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pton,
  ecto_repos: [Pton.Repo]

# Configures the endpoint
config :pton, PtonWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "s4tIoKzMtY/1du9dRJIe/4kUdLNdUjisQvy0XjWAhFyFI63WNwxFWXL5KbyMbzwH",
  render_errors: [view: PtonWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Pton.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# For information about Princeton's CAS system, see:
# https://sp.princeton.edu/oit/eis/iam/authentication/CAS/CAS%20Developer%20KB.aspx
config :ueberauth, Ueberauth,
  providers: [cas: {Ueberauth.Strategy.CAS, [
    base_url: "https://fed.princeton.edu/cas",
    callback: "https://pton.co/auth/cas/callback",
  ]}]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
