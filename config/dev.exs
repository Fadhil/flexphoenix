use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :flexphoenix, Flexphoenix.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin"]]

# Watch static and templates for browser reloading.
config :flexphoenix, Flexphoenix.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{web/views/.*(ex)$},
      ~r{web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development.
# Do not configure such in production as keeping
# and calculating stacktraces is usually expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :flexphoenix, Flexphoenix.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_DEV_USERNAME"),
  password: System.get_env("POSTGRES_DEV_PASSWORD"),
  database: "flexphoenix_dev",
  hostname: "localhost",
  pool_size: 10

config :flexphoenix, ecto_repos: [Flexphoenix.Repo]

config :arc,
  bucket: System.get_env("FLEX_AWS_S3_BUCKET"),
	asset_host: System.get_env("FLEX_AWS_S3_ENDPOINT")

config :ex_aws,
  virtual_host: true,
  access_key_id: [{:system, "FLEX_AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "FLEX_AWS_SECRET_ACCESS_KEY"}, :instance_role],
  region: "ap-southeast-1"
