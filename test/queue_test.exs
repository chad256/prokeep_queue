defmodule Prokeep.QueueTest do
  use ExUnit.Case

  alias Prokeep.Queue

  setup do
    DynamicSupervisor.start_child(
      Prokeep.QueueSupervisor,
      {Queue, :foo}
    )

    Queue.process_messages(:foo)

    :ok
  end

  defp receive_message do
    receive do
      {:io_request, pid, reply_as, {:put_chars, :unicode, msg}} ->
        Agent.update(:processed_messages, fn p_msgs -> List.insert_at(p_msgs, -1, msg) end)
        send(pid, {:io_reply, reply_as, :ok})
    end
  end

  test "a queue only processes 1 message within rate limit" do
    pid = Process.whereis(:foo)
    Process.group_leader(pid, self())
    Agent.start(fn -> [] end, name: :processed_messages)

    ["one", "two", "three", "four", "five"]
    |> Enum.each(&Prokeep.enqueue("foo", &1))

    receive_message()
    receive_message()
    receive_message()
    receive_message()
    receive_message()

    times_processed_at_in_seconds =
      Agent.get(:processed_messages, fn msgs -> msgs end)
      |> Enum.map(fn msg ->
        msg
        |> String.split(" ")
        |> Enum.at(0)
        |> String.split(":")
        |> Enum.at(-1)
        |> String.to_float()
      end)

    rate_limit_in_seconds = Prokeep.rate_limit() / 1000

    times_processed_at_in_seconds
    |> Enum.scan(fn next_time, time ->
      assert next_time - time > rate_limit_in_seconds
      next_time
    end)
  end
end
