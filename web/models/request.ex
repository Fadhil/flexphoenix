defmodule Flexphoenix.Request do
  use Flexphoenix.Web, :model

  schema "requests" do
    field :worktype, :string
    field :title, :string
    field :location, :string
    field :description, :string

    timestamps
  end

  @required_fields ~w(worktype title location description)
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
