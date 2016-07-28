defmodule Flexphoenix.Router do
  use Flexphoenix.Web, :router
  use Passport

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :current_user
    plug Flexphoenix.Plugs.MenuItems
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

	pipeline :no_layout do
		plug :put_layout, false
	end

  scope "/", Flexphoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/forget-password", PasswordController, :forget_password
    post "/reset-password", PasswordController, :reset_password
    resources "/projects", ProjectController do
      resources "/assets", AssetController
    end
    resources "/orders", OrderController
  end

	scope "/", Flexphoenix do
		pipe_through [:browser, :no_layout]
		get "/skin-config", PageController, :skin_config
	end

  # Other scopes may use custom stacks.
  # scope "/api", Flexphoenix do
  #   pipe_through :api
  # end
end
