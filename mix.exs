defmodule RemoteLogging.MixProject do
  use Mix.Project

  def project do
    [
      app:     :remote_logging,
      version: "0.1.0",
      elixir:  "~> 1.6",
      deps:    deps()
    ]
  end

  def application, do: [
    mod: { RemoteLogging, [] },
  ]

  defp deps do
    [
     # bunyan: ">= 0.0.0",
     { :bunyan, path: "../bunyan", env: Mix.env },
    ]
  end
end
