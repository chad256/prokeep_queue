defmodule ProkeepWeb.Router do
  use ProkeepWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ProkeepWeb do
    pipe_through :api

    get "/receive-message", MessageController, :receive
  end
end
