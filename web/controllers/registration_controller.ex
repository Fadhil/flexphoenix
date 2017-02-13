defmodule Flexcility.RegistrationController do
  use Flexcility.Web, :controller

  alias Flexcility.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    conn
    |> put_layout("none.html")
    |> render(:new, user: changeset, changeset: changeset)
  end

  def create(conn, %{"user" => registration_params}) do
    changeset = User.registration_changeset(%User{}, registration_params)
    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Account created!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_layout("none.html")
        |> render(:new, user: changeset, changeset: changeset)
    end
  end

end
