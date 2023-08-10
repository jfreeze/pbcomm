defmodule Pbcomm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Pbcomm.Worker.start_link(arg)
      # {Pbcomm.Worker, arg}
      {Phoenix.PubSub, name: Pbcomm.PubSub},
      Pbcomm.Message
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pbcomm.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
