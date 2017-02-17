defmodule Flexcility.RegistrationController do
  use Flexcility.Web, :controller

  alias Flexcility.User
  
  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{profile: %{}})
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

  defp get_full_name(%{
    "first_name" => first_name,
    "last_name" => last_name} = registration_params) do

    first_name <> " " <> last_name
  end

  def get_user_changeset_with_profile(params) do
    profile_params = %{"full_name" => get_full_name(params)}
    params_with_profile = params |> Map.put("profile", profile_params)
    changeset = User.registration_changeset(%User{}, params_with_profile)
  end
end
