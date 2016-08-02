defmodule Flexphoenix.RequestView do
  use Flexphoenix.Web, :view
  alias Flexphoenix.Repo

  def project_list(user) do
    all_projects(user)
    |> Enum.uniq
    |> Enum.map(fn x -> {x.name, x.id} end)
  end

  def asset_list(user, project_id) do
    selected_project = all_projects(user)
      |> Enum.find(fn project -> project.id == project_id end)
      |> Repo.preload(:assets)

    selected_project.assets
    |> Enum.map(fn x -> {x.name, x.id} end)
  end

  def all_projects(user) do
    user.attached_projects ++ user.projects
  end
end
