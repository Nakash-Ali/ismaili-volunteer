defmodule VolunteerWeb.Router do
  use VolunteerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :drop
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/legacy", VolunteerWeb do
    pipe_through :api

    post "/apply", LegacyController, :apply
  end

  scope "/", VolunteerWeb do
    pipe_through :browser

    # resources "/regions", RegionController
    # resources "/jamatkhanas", JamatkhanaController
    # resources "/groups", GroupController
  end

  scope "/", VolunteerWeb do
    pipe_through :api

    get "/", IndexController, :index
  end

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  defp drop(conn, _) do
    conn
      |> send_resp(400, "not found")
      |> halt
  end
end
