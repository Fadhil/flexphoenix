defmodule Flexphoenix.RequestView do
  use Flexphoenix.Web, :view

  def project_list(user) do
    all_projects(user)
    |> Enum.uniq
    |> Enum.map(fn x -> {x.name, x.id} end)
  end


  def all_projects(user) do
    user.attached_projects ++ user.projects
  end
end
