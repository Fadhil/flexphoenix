defmodule Flexcility.SubdomainRouter do
  use Flexcility.Web, :router
  use Passport

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :current_user
    plug :put_layout, {Flexcility.LayoutView, :organisation_layout}
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :current_user
  end

  pipeline :no_layout do
    plug :put_layout, "none.html"
  end

  pipeline :set_menu do
    plug Flexcility.Plugs.MenuItems
  end

  pipeline :redirect_logged_in_user do
    plug Flexcility.Plugs.RedirectLoggedInUser
  end

  pipeline :authorize do
    plug Flexcility.Plugs.Authorize
    plug Flexcility.Plugs.AuthorizeForOrganisation
  end

  pipeline :load_profile do
    plug Flexcility.Plug.LoadProfile
  end

  scope "/", Flexcility.Subdomain do
    pipe_through [:browser, :authorize, :load_profile] # Use the default browser stack
    # get "/", DashboardController, :index
    get "/dashboard", DashboardController, :index
    get "/profile", ProfileController, :show
    put "/profile", ProfileController, :update
  end

  scope "/", Flexcility.Subdomain do
    pipe_through [:browser, :no_layout]
    get "/logout", SessionController, :delete
    get "/invitations/:invitation_key", InvitationController, :show
    post "/invitations/:invitation_key/accept", InvitationController, :accept
    post "/invitations/:invitation_key/reject", InvitationController, :reject
  end

  scope "/", Flexcility.Subdomain do
    pipe_through [:browser, :redirect_logged_in_user]
    get "/login", SessionController, :new
    get "/", SessionController, :new
    get "/login/:invitation_key", SessionController, :invitation
    post "/login", SessionController, :create
  end

  scope "/", Flexcility do
    pipe_through [:browser]
    get "/register", RegistrationController, :invitation
    post "/register", RegistrationController, :create
  end
  #
  # scope "/", Flexcility.Subdomain do
  #   pipe_through [:browser, :redirect_logged_in_user]
  #   get "/register", RegistrationController, :new
  #   post "/register", RegistrationController, :create
  #   get "/forget-password", PasswordController, :forget_password
  #   post "/reset-password", PasswordController, :reset_password
  # end



  # Other scopes may use custom stacks.
  # scope "/api", Flexcility do
  #   pipe_through :api
  # end
end
