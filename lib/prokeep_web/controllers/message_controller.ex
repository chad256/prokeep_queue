defmodule ProkeepWeb.MessageController do
  use ProkeepWeb, :controller

  def receive(conn, %{"message" => message, "queue" => queue_name}) do
    Prokeep.enqueue(queue_name, message)
    render(conn, "receive-message.json")
  end
end
