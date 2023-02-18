defmodule Prokeep.Queue do
  use GenServer

  def start_link(queue_name) do
    GenServer.start_link(__MODULE__, queue_name, name: queue_name)
  end

  def enqueue(queue_name, message) do
    GenServer.cast(String.to_atom(queue_name), {:enqueue, message})
  end

  def process_messages(queue_name) do
    Process.send(queue_name, :process_messages, [])
  end

  def init(queue_name) do
    Process.flag(:trap_exit, true)

    queue =
      case :ets.lookup(:queues_table, queue_name) do
        [] ->
          []

        [{^queue_name, queue}] ->
          queue
      end

    {:ok, %{name: queue_name, queue: queue}}
  end

  def handle_cast({:enqueue, message}, %{name: name, queue: queue}) do
    reversed_queue = Enum.reverse(queue)
    new_queue = Enum.reverse([message | reversed_queue])
    {:noreply, %{name: name, queue: new_queue}}
  end

  def handle_info(:process_messages, %{queue: []} = state) do
    Process.send_after(self(), :process_messages, Prokeep.rate_limit())
    {:noreply, state}
  end

  def handle_info(:process_messages, %{name: name, queue: [hd | tail]}) do
    IO.inspect(hd, label: "#{Time.utc_now()} [message]")
    Process.send_after(self(), :process_messages, Prokeep.rate_limit())
    {:noreply, %{name: name, queue: tail}}
  end

  def terminate(_, %{name: name, queue: queue}) do
    :ets.insert(:queues_table, {name, queue})
    :ok
  end
end
