defmodule Flexphoenix.ProjectView do
  use Flexphoenix.Web, :view
  alias Flexphoenix.Repo

  def project_members(project) do
    %{members: members} = project |> Repo.preload(members: [:roles])
    members |> Enum.map(fn m ->
      %{email: m.email, roles: Enum.map(m.roles, fn r ->
        %{name: r.name}
      end)}
    end )
  end

  def show_role_names(roles) do
    roles
    |> Enum.map(fn r -> r.name end)
    |> Enum.join(",")
  end
end
