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

  scope "/auth", VolunteerWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :logout
  end

  scope "/legacy", VolunteerWeb.Legacy do
    pipe_through :api

    post "/apply", ApplyController, :apply
  end

  scope "/admin", VolunteerWeb.Admin, as: :admin do
    pipe_through :browser

    get "/", IndexController, :index
    resources "/listings", ListingController
  end

  scope "/", VolunteerWeb do
    pipe_through :api

    get "/", IndexController, :index
  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

end
