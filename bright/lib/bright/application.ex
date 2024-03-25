defmodule Bright.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BrightWeb.Telemetry,
      Bright.Repo,
      {DNSCluster, query: Application.get_env(:bright, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Bright.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Bright.Finch},
      # Start a worker by calling: Bright.Worker.start_link(arg)
      # {Bright.Worker, arg},
      # Start to serve requests, typically the last entry
      BrightWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bright.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BrightWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
