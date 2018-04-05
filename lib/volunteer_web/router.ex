defmodule VolunteerWeb.Router do
  use VolunteerWeb, :router
  import VolunteerWeb.Session.Plugs, only: [load_current_user: 2, ensure_authenticated: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/legacy", VolunteerWeb.Legacy do
    pipe_through :api

    post "/apply", ApplyController, :apply
  end

  scope "/", VolunteerWeb do
    pipe_through :browser

    get "/", IndexController, :index
    resources "/listings", ListingController, only: [:show]

    scope "/auth" do
      get "/login", AuthController, :login
      get "/logout", AuthController, :logout
      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
      post "/:provider/callback", AuthController, :callback
    end

    scope "/admin", Admin, as: :admin do
      pipe_through [:ensure_authenticated]

      get "/", IndexController, :index
      
      resources "/listings", ListingController
      post "/listings/:id/approve", ListingController, :approve
      post "/listings/:id/unapprove", ListingController, :unapprove
    end
  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
