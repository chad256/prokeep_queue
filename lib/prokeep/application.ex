defmodule Prokeep.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :ets.new(:queues_table, [:named_table, :public])

    children = [
      ProkeepWeb.Telemetry,
      {Phoenix.PubSub, name: Prokeep.PubSub},
      ProkeepWeb.Endpoint,
      {DynamicSupervisor, name: Prokeep.QueueSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Prokeep.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    ProkeepWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
