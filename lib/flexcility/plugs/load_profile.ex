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
        #Redirect to new profile page if no profile found
        redirect_path = Helpers.profile_path(conn, :new)

        conn
        |> Phoenix.Controller.redirect(to: redirect_path)
        |> halt
      _ ->
        # preload user with profile
        user = user |> Repo.preload([:profile])
        conn
        |> assign(:current_user, user)

    end
  end
end
