defmodule Flexphoenix.Plugs.Authorize do
  import Plug.Conn
  alias Flexphoenix.Repo
  alias Flexphoenix.User
  alias Flexphoenix.Project

  def init(defaults), do: defaults

  def call(conn, _) do
    user = conn.assigns.current_user
    case user do
      nil ->
        conn
        |> Phoenix.Controller.redirect(to: "/login")

      _ -> conn
    end
  end
end
