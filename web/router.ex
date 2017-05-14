defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # this is my custom plug
    # it will set the current user to the conn module
    plug Discuss.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack
    # get "/", TopicController, :index
    # get "/topics/new", TopicController, :new
    # post "/topics", TopicController, :create
    # get "/topics/:id/edit", TopicController, :edit
    # put "/topics/:id", TopicController, :update

    # resources from the topics ("/" would make ex: localhost:4000/5/edit)

    resources "/", TopicController
  end

  scope "/auth", Discuss do
    pipe_through :browser

    get "/signout", AuthController, :signout
    # ':provider' is a flexible way to handle this instead of just put 'github' or 'facebook'
    get "/:provider", AuthController, :request # the action 'request' comes from the hidden lib
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
