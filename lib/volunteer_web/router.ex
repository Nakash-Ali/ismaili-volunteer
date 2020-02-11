defmodule VolunteerWeb.Router do
  use VolunteerWeb, :router
  use Plug.ErrorHandler
  use Sentry.Plug
  import VolunteerWeb.SessionIdentifier.Plugs, only: [ensure_unique_session_identifier: 2]
  import VolunteerWeb.ConnPermissions.Plugs, only: [ensure_permissioned: 2]
  import VolunteerWeb.UserSession.Plugs, only: [authenticate_user: 2, ensure_authenticated: 2, annotate_roles_for_user: 2]
  import VolunteerWeb.UserPrefs.Plugs, only: [fetch_user_prefs: 2]

  @user_prefs %{
    admin_feedback_anonymize: {:boolean, false}
  }

  pipeline :ssl? do
    if Application.fetch_env!(:volunteer, :use_ssl) do
      plug Plug.SSL, rewrite_on: [:x_forwarded_proto], expires: 604_800
    end
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :ensure_unique_session_identifier
    plug :authenticate_user
    plug :configure_sentry_context
    plug :fetch_user_prefs, @user_prefs
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # pipeline :embedded do
  #   plug :allow_embedding_as_frame
  #   plug :put_embedded_layout
  # end

  forward "/sent_emails", Bamboo.SentEmailViewerPlug

  get "/health/ping", VolunteerWeb.HealthController, :ping

  scope "/api", VolunteerWeb.API do
    pipe_through :ssl?
    pipe_through :api

    resources "/listings", ListingController, only: [:index]
  end

  # scope "/", VolunteerWeb, host: "embedded." do
  #   pipe_through :ssl?
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

  scope "/", VolunteerWeb do
    pipe_through :ssl?
    pipe_through :browser

    get "/", IndexController, :index
    get "/feedback/*path", FeedbackController, :index

    get "/privacy", DisclaimersController, :privacy
    get "/terms", DisclaimersController, :terms

    resources "/listings", ListingController, only: [:show] do
      post "/", Listing.ApplyController, :create

      scope "/social_image" do
        get "/show", Listing.SocialImageController, :show
        get "/png", Listing.SocialImageController, :png
      end

      scope "/preview" do
        get "/index/", Listing.PreviewController, :index
        get "/show/", Listing.PreviewController, :show
      end
    end

    scope "/admin", Admin, as: :admin do
      pipe_through :ensure_permissioned
      pipe_through :ensure_authenticated
      pipe_through :annotate_roles_for_user

      get "/", IndexController, :index

      resources "/listings", ListingController do
        scope "/public" do
          get "/approve", Listing.PublicController, :approve_confirmation
          post "/approve", Listing.PublicController, :approve
          post "/unapprove", Listing.PublicController, :unapprove
          post "/request_approval", Listing.PublicController, :request_approval
          post "/refresh", Listing.PublicController, :refresh
          post "/expire", Listing.PublicController, :expire
          post "/reset", Listing.PublicController, :reset

          resources "/marketing_request", MarketingRequestController,
            singleton: true,
            only: [:new, :create]
        end

        scope "/tkn" do
          resources "/", Listing.TKNController,
            singleton: true,
            only: [:show, :edit, :update]

          scope "/assignment_spec" do
            get "/show", TKNAssignmentSpecController, :show
            get "/pdf", TKNAssignmentSpecController, :pdf
            post "/send", TKNAssignmentSpecController, :send
          end
        end

        scope "/applicants" do
          resources "/", ApplicantController, only: [:index]
          get "/export", ApplicantController, :export
        end

        resources "/roles", RoleController, only: [:index, :new, :create, :delete]
      end

      resources "/users", UserController, only: [:index]

      resources "/regions", RegionController, only: [:index, :show] do
        resources "/roles", RoleController, only: [:index, :new, :create, :delete]
      end

      resources "/groups", GroupController, only: [:index, :show] do
        resources "/roles", RoleController, only: [:index, :new, :create, :delete]
      end

      get "/feedback/*path", FeedbackController, :index


      scope "/system" do
        get "/env", SystemController, :env
        get "/app", SystemController, :app
        get "/endpoint", SystemController, :endpoint
        get "/req_headers", SystemController, :req_headers
        get "/spoof", SystemController, :spoof
      end
    end

    scope "/auth" do
      get "/login", AuthController, :login
      get "/logout", AuthController, :logout
      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
      post "/:provider/callback", AuthController, :callback
    end

    get "/groups/:id", GroupController, :show

    get "/regions/:id", RegionController, :show
    get "/:slug", RegionController, :show_by_slug
  end

  def configure_sentry_context(conn, _opts) do
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
