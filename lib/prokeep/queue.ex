defmodule Prokeep.Queue do
  use GenServer

  def start_link(%{queue: queue_name} = params) do
    GenServer.start_link(__MODULE__, params, name: String.to_atom(queue_name))
  end

  def enqueue(queue_name, message) do
    GenServer.cast(String.to_atom(queue_name), {:enqueue, message})
  end

  def init(%{message: message}) do
    send(self(), :process_messages)
    {:ok, [message]}
  end

  def handle_cast({:enqueue, message}, queue) do
    reversed_queue = Enum.reverse(queue)
    new_queue = Enum.reverse([message | reversed_queue])

    {:noreply, new_queue}
  end

  def handle_info(:process_messages, []) do
    Process.send_after(self(), :process_messages, 1000)
    {:noreply, []}
  end

  def handle_info(:process_messages, [hd | tail]) do
    IO.inspect(hd, label: "#{Time.utc_now()} [message]")
    Process.send_after(self(), :process_messages, Prokeep.rate_limit())
    {:noreply, tail}
  end
end
