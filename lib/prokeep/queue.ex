defmodule Prokeep.Queue do
  use GenServer

  def start_link(%{queue: queue_name} = params) do
    GenServer.start_link(__MODULE__, params, name: String.to_atom(queue_name))
  end

  def enqueue(queue_name, message) do
    GenServer.cast(String.to_atom(queue_name), %{message: message})
  end

  def init(%{message: message}) do
    {:ok, [message]}
  end

  def handle_cast(%{message: message}, queue) do
    {:noreply, [message | queue]}
  end
end
