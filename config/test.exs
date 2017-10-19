use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pton, PtonWeb.Endpoint,
  http: [port: 4001],
  server: false,
  google_api_key: Map.get(System.get_env(), "GOOGLE_API_KEY", "")

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :pton, Pton.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "pton_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
