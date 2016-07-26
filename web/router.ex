defmodule Flexphoenix.Router do
  use Flexphoenix.Web, :router

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

	pipeline :no_layout do
		plug :put_layout, false
	end

  scope "/", Flexphoenix do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
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
