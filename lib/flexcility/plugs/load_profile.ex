defmodule Flexcility.Plug.LoadProfile do
  import Plug.Conn
  alias Flexcility.Repo
  alias Flexcility.Router.Helpers
  require IEx
  def init(defaults), do: defaults

  def call(conn, _) do
    user = conn.assigns.current_user
           |> Repo.preload([:profile])

    case user.profile do
      nil ->
        redirect_path = Helpers.profile_path(conn, :new)

        conn
        |> Phoenix.Controller.redirect(to: redirect_path)
        |> halt
      _ ->

        conn
        |> assign(:current_user, user)

    end
  end
end
