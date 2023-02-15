defmodule ProkeepWeb.MessageController do
  use ProkeepWeb, :controller

  def receive(conn, %{"message" => message, "queue" => queue}) do
    render(conn, "receive-message.json")
  end
end
