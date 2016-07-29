defmodule Flexphoenix.UsersRole do
  use Flexphoenix.Web, :model

  schema "users_roles" do
    belongs_to :user, Flexphoenix.User
    belongs_to :role, Flexphoenix.Role

    timestamps
  end

  @required_fields ~w()
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
end
