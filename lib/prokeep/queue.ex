defmodule Prokeep.Queue do
  use GenServer

  def start_link(queue) do
    GenServer.start_link(__MODULE__, queue, name: String.to_atom(queue))
  end

  def enqueue(queue, message) do
    new_list =
      case :ets.lookup(:queues_table, queue) do
        [] ->
          [message]

        [{^queue, list}] ->
          reversed_list = Enum.reverse(list)
          Enum.reverse([message | reversed_list])
      end

    :ets.insert(:queues_table, {queue, new_list})
  end

  def init(queue) do
    send(self(), :process_messages)
    {:ok, queue}
  end

  def handle_info(:process_messages, queue) do
    with [{^queue, [hd | tail]}] <- :ets.lookup(:queues_table, queue) do
      IO.inspect(hd, label: "#{Time.utc_now()} [message]")
      :ets.insert(:queues_table, {queue, tail})
    end

    Process.send_after(self(), :process_messages, Prokeep.rate_limit())
    {:noreply, queue}
  end
end
