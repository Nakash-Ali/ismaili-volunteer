defmodule VolunteerWeb.Router do
  use VolunteerWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug
  import VolunteerWeb.UserSession.Plugs, only: [authenticate_user: 2, ensure_authenticated: 2]
  import VolunteerWeb.SessionIdentifier.Plugs, only: [ensure_unique_session_identifier: 2]
  import VolunteerWeb.UserPrefs, only: [fetch_user_prefs: 2]

  @user_prefs %{
    admin_feedback_anonymize: {:boolean, false}
  }

  pipeline :browser do
    if Application.fetch_env!(:volunteer, :use_ssl) do
      plug Plug.SSL, rewrite_on: [:x_forwarded_proto], expires: 604_800
    end

    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :ensure_unique_session_identifier
    plug :authenticate_user
    plug :configure_sentry_context
    plug :fetch_user_prefs, @user_prefs
    # plug VolunteerWeb.HTMLMinifier
  end

  # pipeline :embedded do
  #   plug :allow_embedding_as_frame
  #   plug :put_embedded_layout
  # end
  #
  # scope "/", VolunteerWeb, host: "embedded." do
  #   pipe_through :browser
  #   pipe_through :embedded
  #
  #   get "/", Embedded.IndexController, :index
  #
  #   scope "/listings/:id" do
  #     get "/", ListingController, :show
  #   end
  #
  #   match :*, "/*path", NoRouteErrorController, :raise_error
  # end

  forward "/sent_emails", Bamboo.SentEmailViewerPlug

  scope "/", VolunteerWeb do
    pipe_through :browser

    get "/", IndexController, :index
    get "/feedback/*path", FeedbackController, :index

    get "/privacy", DisclaimersController, :privacy
    get "/terms", DisclaimersController, :terms

    scope "/listings/:id" do
      get "/", ListingController, :show
      post "/", ListingController, :create_applicant

      scope "/social_image" do
        get "/show", ListingSocialImageController, :show
        get "/png", ListingSocialImageController, :png
      end

      scope "/preview" do
        get "/index/", ListingPreviewController, :index
        get "/show/", ListingPreviewController, :show
      end
    end

    scope "/admin", Admin, as: :admin do
      pipe_through [:ensure_authenticated]

      get "/", IndexController, :index

      scope "/listings" do
        resources "/", ListingController do
          scope "/tkn_listing" do
            resources "/", TKNListingController, singleton: true

            scope "/assignment_spec" do
              get "/show", TKNAssignmentSpecController, :show
              get "/pdf", TKNAssignmentSpecController, :pdf
            end
          end

          resources "/marketing_request", MarketingRequestController,
            singleton: true,
            only: [:show, :new, :create]

          scope "/applicants" do
            resources "/", ApplicantController, only: [:index]
            get "/export", ApplicantController, :export
          end
        end

        get "/:id/approve", ListingController, :approve_confirmation
        post "/:id/approve", ListingController, :approve
        post "/:id/unapprove", ListingController, :unapprove
        post "/:id/request_approval", ListingController, :request_approval
        post "/:id/refresh_expiry", ListingController, :refresh_expiry
        post "/:id/expire", ListingController, :expire
      end

      resources "/users", UserController, only: [:index]
      resources "/regions", RegionController, only: [:index, :show]
      resources "/groups", GroupController, only: [:index, :show]

      get "/feedback/*path", FeedbackController, :index

      scope "/system" do
        get "/env", SystemController, :env
        get "/app", SystemController, :app
        get "/endpoint", SystemController, :endpoint
      end
    end

    scope "/auth" do
      get "/login", AuthController, :login
      get "/logout", AuthController, :logout
      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
      post "/:provider/callback", AuthController, :callback
    end

    # get "/sentry_correlator/:request_id", SentryCorrelator, :event_id

    get "/regions/:id", RegionController, :show
    get "/:slug", RegionController, :show_by_slug
  end

  def configure_sentry_context(conn, _opts) do
    VolunteerWeb.SentryCorrelator.set_request_id(conn)

    case VolunteerWeb.UserSession.get_user(conn) do
      nil ->
        conn

      user ->
        Sentry.Context.set_user_context(%{id: user.id, username: user.title, email: user.primary_email})
        conn
    end
  end

  # def allow_embedding_as_frame(conn, _opts) do
  #   Plug.Conn.delete_resp_header(conn, "x-frame-options")
  # end
  #
  # def put_embedded_layout(conn, _opts) do
  #   Phoenix.Controller.put_layout(conn, {VolunteerWeb.LayoutView, "embedded.html"})
  # end
end
