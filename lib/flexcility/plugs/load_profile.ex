defmodule Flexcility.Plug.LoadProfile do
  import Plug.Conn
  alias Flexcility.Repo

  def init(defaults), do: defaults

  def call(conn, _) do
    user = conn.assigns.current_user
    case user do
      nil ->
        conn
      _ ->
        user = user |> Repo.preload([:profile])
        conn
        |> assign(:current_user, user)

    end
  end
end
