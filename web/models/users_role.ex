defmodule Flexphoenix.UsersRole do
  use Flexphoenix.Web, :model
  import Ecto.Query, only: [from: 2]

  schema "users_roles" do
    belongs_to :user, Flexphoenix.User
    belongs_to :role, Flexphoenix.Role
    belongs_to :project, Flexphoenix.Project

    timestamps
  end

  @required_fields ~w(user_id role_id project_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def create_changeset(model, repo, users_role_changes = %{
      role_id: role_id, user_id: user_id, project_id: project_id
    }) do

    query = from ur in model,
      where: ur.user_id == ^user_id and ur.role_id == ^role_id and ur.project_id == ^project_id

    result =
      case repo.all(query) do
        # If we get no matches we build an empty map
        [] -> %Flexphoenix.UsersRole{}
        # If we get only the one matching row, we return that user role
        [users_role|[]] -> users_role
      end
      # Get a changeset using either the empty map or the user role (
      # which is returned by Repo.all(query))
      |> changeset(users_role_changes)
  end
end
