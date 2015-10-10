defmodule FullCarendarSample do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(FullCarendarSample.Endpoint, []),
      # Start the Ecto repository
      worker(FullCarendarSample.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(FullCarendarSample.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FullCarendarSample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FullCarendarSample.Endpoint.config_change(changed, removed)
    :ok
  end
end
