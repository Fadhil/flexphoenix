use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :flexcility, Flexcility.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :flexcility, Flexcility.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_DEV_USERNAME"),
  password: System.get_env("POSTGRES_DEV_PASSWORD"),
  database: "flexphoenix_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :flexcility, ecto_repos: [Flexcility.Repo]
