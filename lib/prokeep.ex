defmodule Prokeep do
  alias Prokeep.Queue

  def enqueue(queue_name, message) do
    ensure_queue_exists(queue_name)
    Prokeep.Queue.enqueue(queue_name, message)
  end

  def ensure_queue_exists(queue_name) do
    queue_name = String.to_atom(queue_name)

    if Process.whereis(queue_name) == nil do
      DynamicSupervisor.start_child(
        Prokeep.QueueSupervisor,
        {Queue, queue_name}
      )

      Queue.process_messages(queue_name)
    end
  end

  def rate_limit do
    Application.fetch_env!(:prokeep, :rate_limit)
  end
end
