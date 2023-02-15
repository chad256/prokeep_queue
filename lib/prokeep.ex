defmodule Prokeep do
  def enqueue(queue, message) do
    ensure_queue_exists(queue)
    Prokeep.Queue.enqueue(queue, message)
  end

  def ensure_queue_exists(queue) do
    if Process.whereis(String.to_atom(queue)) == nil do
      DynamicSupervisor.start_child(
        Prokeep.QueueSupervisor,
        {Prokeep.Queue, queue}
      )
    end
  end

  def rate_limit do
    Application.fetch_env!(:prokeep, :rate_limit)
  end
end
