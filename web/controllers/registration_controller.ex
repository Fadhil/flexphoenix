defmodule Flexcility.RegistrationController do
  use Flexcility.Web, :controller
  alias Passport.Session
  alias Flexcility.User
  def new(conn, params) do
    changeset = User.changeset(%User{}, %{profile: %{}})
    conn
    |> put_layout("none.html")
    |> render(:new, user: changeset, changeset: changeset, invitation: params["invitation"])
  end

  def create(conn, %{"user" => registration_params} = params) do

    changeset = User.registration_changeset(%User{}, registration_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        case Session.login(conn, registration_params["email"], registration_params["password"]) do
          {:ok, conn} ->
            case params["invitation"] do
              nil ->
                conn
                |> put_flash(:info, "Account created!")
                |> redirect(to: page_path(conn, :index))
              invitation_id ->
                conn = put_session(conn, :invitation_key, invitation_id)

                conn
                |> put_flash(:info, "You were invited to an Organisation")
                |> redirect(to: organisation_path(conn, :index))
            end
          {:error, _reason, conn} ->
            conn
            |> put_flash(:error, "Invalid username/password combination")
            |> put_layout("none.html")
            |> render(:new)

        end

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
