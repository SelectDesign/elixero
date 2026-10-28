defmodule EliXero.Mixfile do
  use Mix.Project

  def project do
    [app: :elixero, version: "0.1.2", elixir: "~> 1.15", description: description(), package: package(), deps: deps()]
  end

  def application do
    [extra_applications: [:crypto, :httpoison, :logger, :public_key]]
  end

  defp deps do
    [
      # httpoison 3 requires erlang 26
      {:httpoison, "~> 2.0"},
      {:ex_doc, "0.40.4", only: :dev, runtime: false},
      {:earmark_parser, "~> 1.4.46", only: :dev, runtime: false},
      # Matches flow, version 4+ has breaking changes
      {:poison, "~> 3.0"},
      # Matches flow
      {:ecto, "~> 3.7.2"},
      {:sobelow, "~> 0.17", only: [:dev, :test], runtime: false, warn_if_outdated: true}
    ]
  end

  defp description do
    """
    Xero API elixir SDK
    """
  end

  defp package do
    [
      maintainers: ["MJMortimer"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/MJMortimer/elixero"}
    ]
  end
end
