defmodule Flexphoenix.Plugs.MenuItems do
  import Plug.Conn
  alias Flexphoenix.Repo
  alias Flexphoenix.User
  alias Flexphoenix.Project

  def init(defaults), do: defaults

  def call(conn, _) do
    user = conn.assigns.current_user
    case user do
      nil -> assign(conn, :project_menu_items, [])
      _ -> assign_projects(conn, user)
    end
  end

  def get_name_and_id(%{id: id, name: name}) do
    %{id: id, name: name}
  end

  def assign_projects(conn, user) do
    user = Repo.preload user, :projects
    project_menu_items = Enum.map(user.projects, &get_name_and_id/1)
    assign(conn, :project_menu_items, project_menu_items)
  end
end
