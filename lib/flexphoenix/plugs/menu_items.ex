defmodule Flexphoenix.Plugs.MenuItems do
  import Plug.Conn
  alias Flexphoenix.Repo

  def init(defaults), do: defaults

  def call(conn, _) do
    user = conn.assigns.current_user
    case user do
      nil ->
        assign(conn, :own_projects, nil)
        |> assign(:attached_projects, nil)

      _ -> assign_projects(conn, user)
    end
  end

  def get_name_and_id(%{id: id, name: name}) do
    %{id: id, name: name}
  end

  def assign_projects(conn, user) do
    user = Repo.preload user, [:projects, :attached_projects]
    own_projects = Enum.map(user.projects, &get_name_and_id/1)
    attached_projects = Enum.map(user.attached_projects, &get_name_and_id/1)
    assign(conn, :own_projects, own_projects)
    |> assign(:attached_projects, attached_projects)
    |> assign(:current_user, user)
  end
end
