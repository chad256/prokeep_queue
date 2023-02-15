defmodule ProkeepWeb.MessageController do
  use ProkeepWeb, :controller

  def receive(conn, %{"message" => message, "queue" => queue}) do
    Prokeep.enqueue(queue, message)
    render(conn, "receive-message.json")
  end
end
