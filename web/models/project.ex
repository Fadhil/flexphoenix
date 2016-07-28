defmodule Flexphoenix.Project do
  use Flexphoenix.Web, :model

  schema "projects" do
    field :name, :string
    field :description, :string
    field :address, :string

    belongs_to :user, Flexphoenix.User

    timestamps
  end

  @required_fields ~w(name description address)
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
