defmodule Pton.Mixfile do
  use Mix.Project

  def project do
    [
      app: :pton,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Pton.Application, []},
      extra_applications: [
        :ueberauth_cas,
        :logger,
        :runtime_tools,
        :timex,
        :ex_rated,
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
      {:ex_unit_notifier, "~> 0.1", only: :test},
      {:ueberauth, "~> 0.4"},
      {:ueberauth_cas, "~> 1.0.0"},
      {:apex, "~>1.0.0", only: [:dev, :test]},
      {:ex_machina, "~> 2.0", only: :test},
      {:inch_ex, only: :docs},
      {:excoveralls, "~> 0.5.7", only: :test},
      {:timex, "~> 3.1"},
      {:ex_rated, "~> 1.2"},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
