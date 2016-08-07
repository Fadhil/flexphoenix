defmodule Flexphoenix.RequestController do
  use Flexphoenix.Web, :controller

  alias Flexphoenix.Request
  alias Flexphoenix.UsersRole
  alias Flexphoenix.AssignedTechnician

  plug :scrub_params, "request" when action in [:create, :update]
  plug :assign_project_params when action in [:edit]

  def index(
    %{assigns: %{
      assigned_requests: assigned_requests,
      current_user: current_user
      }
    }=conn, _params
  ) do
    requests = (current_user.requests ++ assigned_requests)
      |> Repo.preload([:user])

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
              |> Repo.preload([:project, :asset, :technicians])
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

  def assign_project_params(conn, %{"project_id" => nil}) do
    conn
    |> assign(:project_id, nil)
  end

  def assign_project_params(conn, %{"project_id" => project_id}) do
    conn
    |> assign(:project_id, project_id)
  end

  def assign_project_params(conn, _params) do
    conn
    |> assign(:project_id, nil)
  end

  def assign_technicians(conn, %{"request_id" => request_id}) do
    request = Request
              |> Repo.get(request_id)
              |> Repo.preload([:project, :asset, :technicians])

    technicians = UsersRole
                  |> UsersRole.only_technicians
                  |> Repo.all(project_id: request.project.id)

    conn
    |> render("assign_technicians.html",
               request_id: request_id,
               request: request,
               available_technicians: technicians)
  end

  def create_technician_assignment(conn,
   %{"create_assigned_technicians" => technician_checkboxes,
      "request_id" => request_id }) do

    technicians_added = run_transaction(technician_checkboxes, request_id)

    case technicians_added do
      {:ok, _changes} ->
        conn
        |> put_flash(:info, "Successfully assigned technicians")
        |> redirect(to: request_path(conn, :show, request_id))
      {:error, _} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: request_path(conn, :assign_technicians, request_id))
    end
  end

  @doc """
  Runs transactions to add or remove assignment of technicians to a request.
  The technician_checkboxes are from the params for the assign technician
  form. They come in the shape
      ```
      Parameters: %{"create_assigned_technicians" =>
                      %{"12" => "true", "3" => "false"}, "request_id" => "9"}
      ```
  where the integer in the key portion of the key value pairs (i.e. "12" & "3")
  are the user ids of the technicians that are to be acted upon, and the value
  portion (true/false) represents if the checkbox was ticked or not.

  For true values, we insert the user_id and request_id into AssignedTechnician.
  For false, we delete entries with the user_id and request_id
  """
  def run_transaction(technician_checkboxes, request_id) do
    request_id = String.to_integer(request_id)

    Repo.transaction(fn ->
         technician_checkboxes
          |> Enum.map(fn {user_id, checked} ->
                case checked do
                  "true" ->
                    insert_technician_assignment(user_id, request_id)
                  "false" ->
                    remove_technician_assignment(user_id, request_id)
                end
              end)
          end)
  end

  def insert_technician_assignment(user_id, request_id) do
    assignment_params = [user_id: user_id, request_id: request_id]

    case Repo.get_by(AssignedTechnician, assignment_params) do
      nil -> %AssignedTechnician{}
      assigned_technician -> assigned_technician
    end
    |> AssignedTechnician.changeset(%{user_id: user_id, request_id: request_id})
    |> Repo.insert_or_update
  end

  def remove_technician_assignment(user_id, request_id) do
    assignment_params = [user_id: user_id, request_id: request_id]

    case Repo.get_by(AssignedTechnician, assignment_params) do
      nil -> nil# If we didn't find one, we don't do anything
      assigned_technician -> Repo.delete!(assigned_technician)
    end
  end
end
