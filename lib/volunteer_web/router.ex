defmodule VolunteerWeb.Router do
  use VolunteerWeb, :router
  import VolunteerWeb.UserSession.Plugs, only: [load_current_user: 2, ensure_authenticated: 2]
  import VolunteerWeb.SessionIdentifier.Plugs, only: [ensure_unique_session_identifier: 2]

  pipeline :browser do
    if Mix.env() == :prod do
      plug Plug.SSL, rewrite_on: [:x_forwarded_proto], expires: 604_800
    end

    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :ensure_unique_session_identifier
    plug :load_current_user
    plug :configure_sentry_context
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

    scope "/listings/:id" do
      get "/", ListingController, :show
      post "/apply", ListingController, :create_applicant

      scope "/social" do
        get "/html", ListingSocialImageController, :show
        get "/image", ListingSocialImageController, :image
      end

      scope "/preview" do
        get "/index/", ListingPreviewController, :index
        get "/show/", ListingPreviewController, :show
      end
    end

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

        resources "/marketing_request", MarketingRequestController,
          singleton: true,
          only: [:show, :new, :create]

        resources "/applicant", ApplicantController, only: [:index]
      end

      post "/listings/:id/approve", ListingController, :approve
      post "/listings/:id/unapprove", ListingController, :unapprove
      post "/listings/:id/refresh_expiry", ListingController, :refresh_expiry
      post "/listings/:id/expire", ListingController, :expire

      get "/feedback/*path", FeedbackController, :index
    end
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  def configure_sentry_context(conn, _params) do
    case conn.assigns[:current_user] do
      nil ->
        conn

      user ->
        Sentry.Context.set_user_context(%{title: user.title, id: user.id})
        conn
    end
  end
end
