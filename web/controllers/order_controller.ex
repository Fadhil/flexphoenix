defmodule Flexphoenix.OrderController do
  use Flexphoenix.Web, :controller

  alias Flexphoenix.Order
  alias Flexphoenix.Request

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
    render(conn, "new.html", changeset: changeset, request_id: request_id, name: "faruq")
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
    render(conn, "edit.html", order: order, changeset: changeset)
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
end
