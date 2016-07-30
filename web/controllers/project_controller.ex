defmodule Flexphoenix.ProjectController do
  use Flexphoenix.Web, :controller

  alias Flexphoenix.Project
  alias Flexphoenix.UsersRole
  alias Flexphoenix.Role
  alias Flexphoenix.User
  import Ecto.Query, only: [from: 2]

  plug :scrub_params, "project" when action in [:create, :update]

  def index(conn, _params) do
    projects = Repo.all(Project)
    render(conn, "index.html", projects: projects)
  end

  def invite_user(conn, %{
    "invite_user" => %{
      "user_email" => email,
      "user_role" => role_id
    },
    "project_id" => project_id
  }) do
    user = User |> Repo.get_by(email: email)
    project = Project |> Repo.get(project_id)
    role = Role |> Repo.get(role_id)

    users_role_changes= %{
      role_id: role.id, user_id: user.id, project_id: project.id
    }

    changeset = UsersRole.create_changeset(
      UsersRole,Repo, users_role_changes
    )

    case Repo.insert_or_update(changeset) do
      {:ok, users_role} ->
        conn
        |> put_flash(:info, "Successfully invited #{email} as #{role.name}")
        |> redirect(to: project_path(conn, :show, project))
      {:error, changeset} ->
        text conn, inspect(changeset)
      _ -> text conn, "yes"
    end
  end

  def new(conn, _params) do
    changeset = Project.changeset(%Project{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"project" => project_params}) do
    current_user = conn.assigns.current_user
    changeset = Project.create_changeset(%Project{},current_user.id, project_params)

    case Repo.insert(changeset) do
      {:ok, _project} ->
        conn
        |> put_flash(:info, "Project created successfully.")
        |> redirect(to: project_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    roles = Role |> Repo.all
    roles_select_list = roles |> Enum.map(fn x -> {"#{x.name}", x.id} end)
    project = Project |> Project.with_owner |> Repo.get!(id)
    render(conn, "show.html", project: project, roles_select_list: roles_select_list)
  end

  def edit(conn, %{"id" => id}) do
    project = Repo.get!(Project, id)
    changeset = Project.changeset(project)
    render(conn, "edit.html", project: project, changeset: changeset)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    project = Repo.get!(Project, id)
    changeset = Project.changeset(project, project_params)

    case Repo.update(changeset) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project updated successfully.")
        |> redirect(to: project_path(conn, :show, project))
      {:error, changeset} ->
        render(conn, "edit.html", project: project, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Repo.get!(Project, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(project)

    conn
    |> put_flash(:info, "Project deleted successfully.")
    |> redirect(to: project_path(conn, :index))
  end
end
