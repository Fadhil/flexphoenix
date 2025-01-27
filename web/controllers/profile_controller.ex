defmodule Flexcility.ProfileController do
  use Flexcility.Web, :controller

  alias Flexcility.Profile
  alias Flexcility.User

  def index(conn, _params) do
    profiles = Repo.all(Profile)
    render(conn, "index.html", profiles: profiles)
  end

  def new(conn, _params) do
    user_id = conn.assigns.current_user.id
    user = Repo.get(User, user_id)|> Repo.preload([:profile])
    changeset = user |> User.changeset(%{})
    conn = conn |> assign(:current_user, user)
    render(conn, "new.html", changeset: changeset, user: user)
  end

  def create(conn, %{"user" => profile_params}) do
    user_id = conn.assigns.current_user.id
    user = Repo.get(User, user_id)|> Repo.preload([:profile])

    changeset = User.update_changeset(user, profile_params)

    case Repo.insert_or_update(changeset) do
      {:ok, user} ->
        user.profile |> Profile.image_changeset(profile_params["profile"]) |> Repo.update

        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: "/")
      {:error, changeset} ->
        render(put_flash(conn, :info, changeset), "new.html", changeset: changeset, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    profile = Repo.get!(Profile, id)
    user = Repo.get!(User, profile.user_id)
           |> Repo.preload([:profile, :organisations])
    render(conn, "show.html", profile: profile, user: user)
  end

  def edit(conn, %{"id" => id}) do
    profile = Repo.get!(Profile, id)
    user = Repo.get!(User, profile.user_id) |> Repo.preload(:profile)
    changeset = User.update_changeset(user)
    render(conn, "edit.html", profile: profile, changeset: changeset, user: user)
  end

  def edit(conn, %{}) do
    user_id = conn.assigns.current_user.id
    user = Repo.get(User, user_id)|> Repo.preload([:profile])
    changeset = user |> User.changeset(%{})
    render(conn, "new.html", changeset: changeset, user: user)
  end


  def update(conn, %{"id" => id, "user" => user_params}) do
    profile = Repo.get!(Profile, id)
    user = Repo.get!(User, profile.user_id) |> Repo.preload([:profile])
    changeset = User.update_changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Profile updated successfully.")
        |> redirect(to: profile_path(conn, :show, user.profile))
      {:error, changeset} ->
        render(conn, "edit.html", profile: profile, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    profile = Repo.get!(Profile, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(profile)

    conn
    |> put_flash(:info, "Profile deleted successfully.")
    |> redirect(to: profile_path(conn, :index))
  end
end
