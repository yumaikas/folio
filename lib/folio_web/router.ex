defmodule FolioWeb.Router do
  use FolioWeb, :router

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

  scope "/", FolioWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/admin", PageController, :admin
    get "/view/bytag/:tag", PageController, :tag
    get "/admin/bytag/:tag", PageController, :admin_tag
    get "/view/idea/:id", PageController, :show
    get "/admin/view/:id", PageController, :edit
    put "/admin/view/:id", PageController, :update
    post "/admin/create/new", PageController, :create
    get "/admin/delete/:id", PageController, :confirm_delete
    delete "/admin/delete/:id", PageController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", FolioWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FolioWeb.Telemetry
    end
  end
end
