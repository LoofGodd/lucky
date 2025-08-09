defmodule BettingWeb.Router do
  use BettingWeb, :router

  import Oban.Web.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {BettingWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :maybe_auth_from_token do
    plug BettingWeb.Plugs.AuthFromToken
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BettingWeb do
    pipe_through :browser
    get "/", PageController, :home
  end

  scope "/", BettingWeb do
    pipe_through [:browser, :maybe_auth_from_token]
    get "/user", UserController, :show
    get "/playing", UserController, :show
  end

  # Other scopes may use custom stacks.
  scope "/api", BettingWeb do
    pipe_through :api
    post "/login", LoginController, :partner_user_login
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:betting, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BettingWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end

    scope "/" do
      pipe_through :browser

      oban_dashboard("/oban")
    end
  end

  if Application.compile_env(:betting, :dev_routes) do
    import AshAdmin.Router

    scope "/admin" do
      pipe_through :browser

      ash_admin "/"
    end
  end
end
