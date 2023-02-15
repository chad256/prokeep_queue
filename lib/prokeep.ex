defmodule Prokeep do
  def enqueue(queue_name, message) do
    case Process.whereis(String.to_atom(queue_name)) do
      nil ->
        # if queue doesn't exist create queue
        DynamicSupervisor.start_child(
          Prokeep.QueueSupervisor,
          {Prokeep.Queue, %{queue: queue_name, message: message}}
        )

      _pid ->
        # else add message to existing queue
        Prokeep.Queue.enqueue(queue_name, message)
    end
  end
end
