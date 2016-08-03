defmodule Flexphoenix.RequestController do
  use Flexphoenix.Web, :controller

  alias Flexphoenix.Request
  alias Flexphoenix.UsersRole

  plug :scrub_params, "request" when action in [:create, :update]
  plug :assign_project_params when action in [:edit]

  def index(conn, _params) do
    requests = Repo.all(Request) |> Repo.preload([:project, :asset])
    render(conn, "index.html", requests: requests)
  end

  def new(conn, params) do
    project_id = case params do
      %{"project_id" => id} -> String.to_integer id
      _ -> nil
    end
    changeset = Request.changeset(%Request{})
    render(conn, "new.html", changeset: changeset, project_id: project_id)
  end

  def create(conn, %{"request" => request_params}) do
    current_user = conn.assigns.current_user
    changeset = Request.create_changeset(%Request{}, current_user.id, request_params)
    %{"project_id" => project_id} = request_params

    case Repo.insert(changeset) do
      {:ok, _request} ->
        conn
        |> put_flash(:info, "Request created successfully.")
        |> redirect(to: request_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, project_id: project_id)
    end
  end

  def show(conn, %{"id" => id}) do
    request = Request
              |> Request.with_owner
              |> Repo.get!(id)
              |> Repo.preload([:project, :asset])
    render(conn, "show.html", request: request)
  end

  def edit(conn, %{"id" => id}) do
    request = Repo.get!(Request, id)
    changeset = Request.changeset(request)
    render(conn, "edit.html", request: request, changeset: changeset)
  end

  def update(conn, %{"id" => id, "request" => request_params}) do
    request = Repo.get!(Request, id)
    changeset = Request.changeset(request, request_params)

    case Repo.update(changeset) do
      {:ok, request} ->
        conn
        |> put_flash(:info, "Request updated successfully.")
        |> redirect(to: request_path(conn, :show, request))
      {:error, changeset} ->
        render(conn, "edit.html", request: request, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    request = Repo.get!(Request, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(request)

    conn
    |> put_flash(:info, "Request deleted successfully.")
    |> redirect(to: request_path(conn, :index))
  end

  def assign_project_params(conn, %{"project_id" => nil} = params) do
    conn
    |> assign(:project_id, nil)
  end

  def assign_project_params(conn, %{"project_id" => project_id} = params) do
    conn
    |> assign(:project_id, project_id)
  end

  def assign_project_params(conn, params) do
    conn
    |> assign(:project_id, nil)
  end

  def assign_technicians(conn, %{"request_id" => request_id} = params) do
    request = Request
              |> Repo.get(request_id)
              |> Repo.preload([:project, :asset])

    technicians = UsersRole
                  |> UsersRole.only_technicians
                  |> Repo.all(project_id: request.project.id)

    conn
    |> render("assign_technicians.html", request_id: request_id, request: request, available_technicians: technicians)
  end
end
