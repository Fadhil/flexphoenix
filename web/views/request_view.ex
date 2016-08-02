defmodule Flexphoenix.RequestView do
  use Flexphoenix.Web, :view

  def project_list(user) do
    attached_projects = user.attached_projects
    own_projects = user.projects

    own_projects ++ attached_projects
    |> Enum.uniq
    |> Enum.map(fn x -> {x.name, x.id} end)
  end
end
