defmodule Parsy.MixProject do
  use Mix.Project

  def project do
    [
      app: :parsy,
      version: "0.1.2",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "A fast syllable-parser for English-language strings",
      package: package(),

      # Docs
      name: "Parsy",
      source_url: "https://github.com/zuchka/parsy.git",
      homepage_url: "https://github.com/zuchka/parsy",
      docs: [api_reference: false,
            # logo: "path/to/logo.png",
             extras:        ["README.md"],
             main:          "Parsy",],
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Parsy.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:benchee, "~> 1.0", only: :dev},
      {:poolboy, "~> 1.5.1"},
    ]
  end

  defp package do
    [
      licenses: ["Apache 2"],
      links: %{sprigg: "https://github.com/zuchka/sprigg.git"},
    ]
  end
end
