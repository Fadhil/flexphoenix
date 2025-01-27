defmodule Flexcility.UsersRole do
  use Flexcility.Web, :model
  import Ecto.Query, only: [from: 2]

  schema "users_roles" do
    belongs_to :user, Flexcility.User
    belongs_to :role, Flexcility.Role
    belongs_to :site, Flexcility.Site

    timestamps
  end

  @required_fields ~w(user_id role_id site_id)
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
      role_id: role_id, user_id: user_id, site_id: site_id
    }) do

    query = from ur in model,
      where: ur.user_id == ^user_id and ur.role_id == ^role_id and ur.site_id == ^site_id

    case repo.all(query) do
      # If we get no matches we build an empty map
      [] -> %Flexcility.UsersRole{}
      # If we get only the one matching row, we return that user role
      [users_role|[]] -> users_role
    end
    # Get a changeset using either the empty map or the user role (
    # which is returned by Repo.all(query))
    |> changeset(users_role_changes)
  end

  def only_technicians(query) do
    from q in query,
      join: u in assoc(q, :user),
      join: r in assoc(q, :role),
      where: r.name == "Technician",
      preload: [user: u]
  end
end
