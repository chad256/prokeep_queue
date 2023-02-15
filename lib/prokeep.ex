defmodule Prokeep do
  def enqueue(queue_name, message) do
    case Process.whereis(String.to_atom(queue_name)) do
      nil ->
        DynamicSupervisor.start_child(
          Prokeep.QueueSupervisor,
          {Prokeep.Queue, %{queue: queue_name, message: message}}
        )

      _pid ->
        Prokeep.Queue.enqueue(queue_name, message)
    end
  end

  def rate_limit do
    Application.fetch_env!(:prokeep, :rate_limit)
  end
end
