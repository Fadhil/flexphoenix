defmodule Flexphoenix.RequestView do
  use Flexphoenix.Web, :view
  alias Flexphoenix.Repo
  import Flexphoenix.LayoutView, only: [display_name: 1]

  def project_list(user) do
    all_projects(user)
    |> Enum.uniq
    |> Enum.map(fn x -> {x.name, x.id} end)
  end

  def asset_list(_user, nil) do
    []
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

  def project_name(nil) do
    "N/A"
  end

  def project_name(project) do
    project.name
  end

  def asset_name(nil) do
    "N/A"
  end

  def asset_name(asset) do
    "#{asset.name} - #{asset.model_id}"
  end
end
