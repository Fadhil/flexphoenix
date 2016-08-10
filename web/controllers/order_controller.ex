defmodule Flexphoenix.OrderController do
  use Flexphoenix.Web, :controller

  alias Flexphoenix.Order
  alias Flexphoenix.Request
  alias Flexphoenix.UsersRole
  alias Flexphoenix.AssignedTechnician

  plug :scrub_params, "order" when action in [:create, :update]

  def index(
    %{assigns: %{current_user: current_user}}=conn, _params
  ) do
    user = current_user |> Repo.preload([:orders])
    orders = user.orders
    render(conn, "index.html", orders: orders)
  end

  def new(conn, %{"request_id" => request_id}) do
    request_fields = [:asset_id, :description, :location, :project_id,
                      :title]

    {request_attributes, _} = Repo.get(Request, request_id)
                              |> Map.from_struct
                              |> Map.split(request_fields)

    request_attributes_with_id = Map.merge(request_attributes, %{request_id: request_id})

    changeset = Order.changeset(%Order{}, request_attributes_with_id)
    render(conn, "new.html", changeset: changeset, request_id: request_id)
  end

  def create(conn, %{"order" => order_params}) do
    current_user = conn.assigns.current_user
    changeset = Order.create_changeset(%Order{}, current_user.id, order_params)

    case Repo.insert(changeset) do
      {:ok, _order} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: order_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    order = Order
            |> Order.with_owner
            |> Repo.get!(id)
            |> Repo.preload([:technicians])
    render(conn, "show.html", order: order)
  end

  def edit(conn, %{"id" => id}) do
    order = Repo.get!(Order, id)
    changeset = Order.changeset(order)
    render(conn, "edit.html",
           order: order, changeset: changeset,
           request_id: changeset.model.request_id)
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    order = Repo.get!(Order, id)
    changeset = Order.changeset(order, order_params)

    case Repo.update(changeset) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order updated successfully.")
        |> redirect(to: order_path(conn, :show, order))
      {:error, changeset} ->
        render(conn, "edit.html", order: order, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    order = Repo.get!(Order, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(order)

    conn
    |> put_flash(:info, "Order deleted successfully.")
    |> redirect(to: order_path(conn, :index))
  end

  def assign_technicians(conn, %{"order_id" => order_id}) do
    preloads = [{:request,[:project, :asset]}, :technicians]
    order = Order
            |> Repo.get(order_id)
            |> Repo.preload(preloads)

    technicians = UsersRole
                  |> UsersRole.only_technicians
                  |> Repo.all(project_id: order.request.project_id)

    conn
    |> render("assign_technicians.html",
              order_id: order_id,
              order: order,
              available_technicians: technicians)
  end

  def create_technician_assignment(conn,
   %{"create_assigned_technicians" => technician_checkboxes,
      "order_id" => order_id }) do

    technicians_added = run_transaction(technician_checkboxes, order_id)

    case technicians_added do
      {:ok, _changes} ->
        conn
        |> put_flash(:info, "Successfully assigned technicians")
        |> redirect(to: order_path(conn, :show, order_id))
      {:error, _} ->
        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: order_path(conn, :assign_technicians, order_id))
    end
  end

  def run_transaction(technician_checkboxes, order_id) do
    order_id = String.to_integer(order_id)

    Repo.transaction(fn ->
         technician_checkboxes
          |> Enum.map(fn {user_id, checked} ->
                case checked do
                  "true" ->
                    insert_technician_assignment(user_id, order_id)
                  "false" ->
                    remove_technician_assignment(user_id, order_id)
                end
              end)
          end)
  end

  def insert_technician_assignment(user_id, order_id) do
    assignment_params = [user_id: user_id, order_id: order_id]

    case Repo.get_by(AssignedTechnician, assignment_params) do
      nil -> %AssignedTechnician{}
      assigned_technician -> assigned_technician
    end
    |> AssignedTechnician.changeset(%{user_id: user_id, order_id: order_id})
    |> Repo.insert_or_update
  end

  def remove_technician_assignment(user_id, order_id) do
    assignment_params = [user_id: user_id, order_id: order_id]

    case Repo.get_by(AssignedTechnician, assignment_params) do
      nil -> nil# If we didn't find one, we don't do anything
      assigned_technician -> Repo.delete!(assigned_technician)
    end
  end
end
