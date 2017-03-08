defmodule Flexcility.Subdomain.ProfileController do
  use Flexcility.Web, :controller
  alias Flexcility.SubdomainRouter
  alias Flexcility.Organisation
  alias Flexcility.User
  require IEx


  def show(conn, _params) do
    user = conn.assigns.current_user
    changeset = User.update_changeset(user)
    render(
      conn, "show.html", user: user, changeset: changeset,
      action: SubdomainRouter.Helpers.profile_path(conn, :update)
    )
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user |> User.with_profile
    changeset = User.update_changeset(user, user_params)
    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> render(
            "show.html", user: user, changeset: changeset,
            action: SubdomainRouter.Helpers.profile_path(
              conn, :update
            )
          )
      {:error, user} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> render(
            "show.html", user: user, changeset: changeset,
            action: SubdomainRouter.Helpers.profile_path(
              conn, :update
            )
          )
    end
  end
end
