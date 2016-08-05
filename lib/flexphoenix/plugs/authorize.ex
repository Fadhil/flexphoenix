defmodule Flexphoenix.Plugs.Authorize do
  import Plug.Conn

  def init(defaults), do: defaults

  def call(conn, _) do
    user = conn.assigns.current_user
    case user do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "You must be logged in to do that")
        |> Phoenix.Controller.redirect(to: "/login")
        |> halt

      _ -> conn
    end
  end
end
