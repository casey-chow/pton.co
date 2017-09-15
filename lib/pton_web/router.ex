defmodule PtonWeb.Router do
  use PtonWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Pton.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", PtonWeb do
    pipe_through :browser
    
    get "/signout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :new
  end

  scope "/", PtonWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/links", LinkController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PtonWeb do
  #   pipe_through :api
  # end
end
