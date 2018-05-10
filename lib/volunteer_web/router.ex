defmodule VolunteerWeb.Router do
  use VolunteerWeb, :router
  import VolunteerWeb.Session.Plugs, only: [load_current_user: 2, ensure_authenticated: 2]

  pipeline :browser do
    if Mix.env == :prod do
      plug Plug.SSL, rewrite_on: [:x_forwarded_proto], expires: 604_800
    end
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_current_user
    plug VolunteerWeb.HTMLMinifier
  end

  scope "/legacy", VolunteerWeb.Legacy do
    pipe_through :browser

    post "/apply", ApplyController, :apply
    get "/thank_you", ApplyController, :thank_you
    get "/error", ApplyController, :error
  end

  scope "/", VolunteerWeb do
    pipe_through :browser

    get "/", IndexController, :index
    
    resources "/listings", ListingController, only: [:show] do
      get "/social_image", ListingSocialImageController, :show
    end
  
    get "/listings/preview/index/:id", ListingPreviewController, :index
    get "/listings/preview/show/:id", ListingPreviewController, :show

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

      resources "/listings", ListingController do
        resources "/tkn_listing", TKNListingController, singleton: true
        resources "/request_marketing", RequestMarketingController, singleton: true, only: [:show, :new, :create]
      end

      post "/listings/:id/approve", ListingController, :approve
      post "/listings/:id/unapprove", ListingController, :unapprove
      post "/listings/:id/archive", ListingController, :unapprove
    end
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end
end
