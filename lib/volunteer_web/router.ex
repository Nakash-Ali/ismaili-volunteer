defmodule VolunteerWeb.Router do
  use VolunteerWeb, :router

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

  scope "/legacy", VolunteerWeb do
    pipe_through :api

    post "/apply", LegacyController, :apply
  end

  scope "/", VolunteerWeb do
    pipe_through :api
    
    get "/", IndexController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", VolunteerWeb do
  #   pipe_through :api
  # end
end
