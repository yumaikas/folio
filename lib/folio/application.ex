defmodule Folio.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Folio.Repo,
      # Start the Telemetry supervisor
      FolioWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Folio.PubSub},
      # Start the Endpoint (http/https)
      FolioWeb.Endpoint
      # Start a worker by calling: Folio.Worker.start_link(arg)
      # {Folio.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Folio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FolioWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
