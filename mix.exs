defmodule Parsy.MixProject do
  use Mix.Project

  def project do
    [
      app: :parsy,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "Parsy",
      source_url: "https://github.com/zuchka/parsy",
      homepage_url: "http://zuchka.dev",
      docs: [api_reference: false,
            # logo: "path/to/logo.png",
             extras:        ["README.md"],
             main:          "Parsy",]]
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
      {:ex_doc, "~> 0.23.0"}    ]
  end
end
