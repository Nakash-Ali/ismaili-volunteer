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
  #   scope "/legacy", Legacy do
  #     post "/apply", ApplyController, :apply
  #     get "/thank_you", ApplyController, :thank_you
  #     get "/error", ApplyController, :error
  #   end
  #
  #   match :*, "/*path", NoRouteErrorController, :raise_error
  # end

  scope "/", VolunteerWeb do
    pipe_through :browser

    get "/", IndexController, :index
    get "/feedback/*path", FeedbackController, :index

    scope "/listings/:id" do
      get "/", ListingController, :show
      post "/apply", ListingController, :create_applicant

      scope "/social_image" do
        get "/show", ListingSocialImageController, :show
        get "/png", ListingSocialImageController, :png
      end

      scope "/preview" do
        get "/index/", ListingPreviewController, :index
        get "/show/", ListingPreviewController, :show
      end
    end

    scope "/legacy", Legacy do
      post "/apply", ApplyController, :apply
      get "/thank_you", ApplyController, :thank_you
      get "/error", ApplyController, :error
    end

    scope "/admin", Admin, as: :admin do
      pipe_through [:ensure_authenticated]

      get "/", IndexController, :index

      resources "/listings", ListingController do
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

        resources "/applicant", ApplicantController, only: [:index]
      end

      get "/listings/:id/approve", ListingController, :approve_confirmation
      post "/listings/:id/approve", ListingController, :approve
      post "/listings/:id/unapprove", ListingController, :unapprove
      post "/listings/:id/request_approval", ListingController, :request_approval
      post "/listings/:id/refresh_expiry", ListingController, :refresh_expiry
      post "/listings/:id/expire", ListingController, :expire

      resources "/users", UsersController, only: [:index]

      get "/feedback/*path", FeedbackController, :index
    end

    scope "/auth" do
      get "/login", AuthController, :login
      get "/logout", AuthController, :logout
      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
      post "/:provider/callback", AuthController, :callback
    end

    get "/regions/:id", RegionController, :show
    get "/:slug", RegionController, :show
  end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  def configure_sentry_context(conn, _opts) do
    case conn.assigns[:current_user] do
      nil ->
        conn

      user ->
        Sentry.Context.set_user_context(%{title: user.title, id: user.id})
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
