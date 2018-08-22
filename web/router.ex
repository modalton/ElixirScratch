defmodule Scratch.Router do
  use Scratch.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Scratch.Auth, repo: Scratch.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Scratch do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/hello/:name", HelloController, :hello

    resources "/users", UserController, only: [:index, :new, :show, :create]

    resources "/sessions", SessionController, only: [:new, :create, :delete]

    get "/watch/:id", WatchController, :show
  end

  scope "/manage", Scratch do
    pipe_through [:browser, :authenticate_user]
    
    resources "/videos", VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Scratch do
  #   pipe_through :api
  # end
end
