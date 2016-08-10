defmodule Flexphoenix.ProjectView do
  use Flexphoenix.Web, :view
  alias Flexphoenix.Repo
  import Flexphoenix.LayoutView, only: [display_name: 1, display_created_at: 1]

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

  def technician?(%{role: %{name: name}}) do
    name == "Technician"
  end

  def admin?(%{role: %{name: name}}) do
    name == "Admin"
  end

  def technicians(members) do
    members
    |> Enum.filter(&technician?/1)
  end

  def admins(members) do
    members
    |> Enum.filter(&admin?/1)
  end

end
