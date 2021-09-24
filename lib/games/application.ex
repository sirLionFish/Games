defmodule Games.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Games.Store,
      Games.Publishers,
      Games.Publisher.Store,
      Games.Platform.Store,
      Games.Pub.Store,
      {Plug.Cowboy, scheme: :http, plug: Games.Router, options: [port: 4000]}
      # Starts a worker by calling: Games.Worker.start_link(arg)
      # {Games.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Games.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
