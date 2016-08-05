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
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :current_user
  end

	pipeline :no_layout do
		plug :put_layout, false
	end

  pipeline :set_menu do
    plug Flexphoenix.Plugs.MenuItems
  end

  pipeline :authorize do
    plug Flexphoenix.Plugs.Authorize
  end

	scope "/", Flexphoenix do
		pipe_through [:browser, :no_layout]
		get "/skin-config", PageController, :skin_config
	end

  scope "/", Flexphoenix do
    pipe_through [:browser]
    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/forget-password", PasswordController, :forget_password
    post "/reset-password", PasswordController, :reset_password
  end

  scope "/", Flexphoenix do
    pipe_through [:browser, :set_menu, :authorize] # Use the default browser stack
    resources "/projects", ProjectController do
      resources "/assets", AssetController
      post "/invite_user", ProjectController, :invite_user
    end
    resources "/requests", RequestController do
      get "/assign_technicians", RequestController, :assign_technicians,
        as: :assign_technicians
      post "/assign_technicians", RequestController, :create_technician_assignment, as: :assign_technicians
    end
    resources "/orders", OrderController
  end

  scope "/api", Flexphoenix do
    pipe_through [:api, :set_menu]

    resources "/projects", ProjectController, only: [] do
      get "/assets", AssetController, :index
    end
  end


  # Other scopes may use custom stacks.
  # scope "/api", Flexphoenix do
  #   pipe_through :api
  # end
end
