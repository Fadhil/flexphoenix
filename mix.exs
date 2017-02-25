defmodule Flexcility.Mixfile do
  use Mix.Project

  def project do
    [app: :flexcility,
     version: "0.22.7",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Flexcility, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :passport, :phoenix_ecto, :postgrex, :comeonin, :arc,
                    :arc_ecto, :timex, :ex_aws, :hackney, :poison, :sweet_xml,
                    :inflex, :bamboo, :bamboo_smtp
                   ]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_ecto, "~> 3.0-rc"},
     {:passport, git: "https://github.com/opendrops/passport.git"},
     {:comeonin, "~> 2.0"},
     {:phoenix_html, "~> 2.4"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.9"},
     {:cowboy, "~> 1.0"},
     {:distillery, "~> 1.0"},
     {:arc, "~> 0.6.0"},
     {:arc_ecto, "~> 0.5.0"},
     {:timex, "~> 3.0"},
     {:ex_aws, "~> 1.0.0"}, # Required if using Amazon S3
     {:hackney, "~> 1.6"},
     {:poison, "~> 2.2"},     # Required if using Amazon S3
     {:sweet_xml, "~> 0.6"},
     {:inflex, "~> 1.7.0"},
     {:bamboo, "~> 0.7"},
     {:bamboo_smtp, "~> 1.2.1"}
	  ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
