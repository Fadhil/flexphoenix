defmodule Flexphoenix.Plugs.Authorize do
  import Plug.Conn
  alias Flexphoenix.Repo
  alias Flexphoenix.User
  alias Flexphoenix.Project
  alias Passport.Session
  alias Flexphoenix.Registration
  alias Flexphoenix.Password

  def init(defaults), do: defaults

  def call(conn, _) do
    user = conn.assigns.current_user
    case user do
      nil ->
        conn
        |> Phoenix.Controller.redirect(to: Flexphoenix.Page.page_path(conn, :index))

      _ -> conn
    end
  end
end
