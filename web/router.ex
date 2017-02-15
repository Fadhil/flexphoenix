defmodule Flexcility.Router do
  use Flexcility.Web, :router
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
    plug Flexcility.Plugs.MenuItems
  end

  pipeline :redirect_logged_in_user do
    plug Flexcility.Plugs.RedirectLoggedInUser
  end

  pipeline :authorize do
    plug Flexcility.Plugs.Authorize
  end

	scope "/", Flexcility do
		pipe_through [:browser, :no_layout]
		get "/skin-config", PageController, :skin_config
	end

  scope "/", Flexcility do
    pipe_through [:browser]
    delete "/logout", SessionController, :delete
  end

  scope "/", Flexcility do
    pipe_through [:browser, :redirect_logged_in_user]
    get "/", PageController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/forget-password", PasswordController, :forget_password
    post "/reset-password", PasswordController, :reset_password
  end

  scope "/", Flexcility do
    pipe_through [:browser, :set_menu, :authorize] # Use the default browser stack
    resources "/organisations", OrganisationController
    resources "/projects", ProjectController do
      resources "/assets", AssetController
      post "/invite_user", ProjectController, :invite_user
    end
    resources "/requests", RequestController do
      get "/assign_technicians", RequestController, :assign_technicians, as: :assign_technicians
      post "/assign_technicians", RequestController, :create_technician_assignment, as: :assign_technicians
    end
    resources "/orders", OrderController do
      get "/assign_technicians", OrderController, :assign_technicians, as: :assign_technicians
      post "/assign_technicians", OrderController, :create_technician_assignment, as: :assign_technicians
    end
    resources "/reports", ReportController
    end

  scope "/api", Flexcility do
    pipe_through [:api, :set_menu]

    resources "/projects", ProjectController, only: [] do
      get "/assets", AssetController, :index
    end
  end

  if Mix.env == :dev do
  # If using Phoenix
  forward "/sent_emails", Bamboo.EmailPreviewPlug

end


  # Other scopes may use custom stacks.
  # scope "/api", Flexcility do
  #   pipe_through :api
  # end
end
