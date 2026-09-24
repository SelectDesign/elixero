defmodule EliXero.Mixfile do
  use Mix.Project

  def project do
    [app: :elixero, version: "0.1.2", elixir: "~> 1.14", description: description(), package: package(), deps: deps()]
  end

  def application do
    [extra_applications: [:crypto, :httpoison, :logger, :public_key]]
  end

  defp deps do
    [
      {:httpoison, "~> 0.9"},
      {:ex_doc, "0.36.1", only: :dev, runtime: false},
      # Earmark Parser 1.4.46 requires Elixir 1.15.
      {:earmark_parser, "1.4.45", only: :dev, runtime: false},
      {:poison, "~> 3.0"},
      {:ecto, "~> 3.0"},
      {:sobelow, "~> 0.15", only: [:dev, :test], runtime: false, warn_if_outdated: true}
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
