defmodule Flexcility.Plugs.RedirectLoggedInUser do
  import Plug.Conn
  require Logger
  def init(defaults), do: defaults

  def call(conn, _) do
    user = conn.assigns.current_user
    case user do
      nil ->
        conn
      _ ->
        conn
        |> redirect_user(user)
    end
  end

  def redirect_user(conn, user) do
    conn
    |> Phoenix.Controller.redirect(to: "/organisations")
    |> halt
  end
end
