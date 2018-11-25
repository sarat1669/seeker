defmodule SeekerWeb.Router do
  @moduledoc false

  use SeekerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SeekerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", SeekerWeb do
    pipe_through :api

    get "/workflows/:id/execute", WorkflowController, :execute
    post "/workflows/:id/execute", WorkflowController, :execute
    resources "/workflows", WorkflowController, except: [:new, :edit]
    resources "/components", ComponentController, except: [:new, :edit]
  end
end
