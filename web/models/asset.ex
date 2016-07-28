defmodule Flexphoenix.Asset do
  use Flexphoenix.Web, :model

  schema "assets" do
    field :name, :string
    field :model_id, :string
    field :manufacturer, :string
    field :photo, :string
    belongs_to :project, Flexphoenix.Project

    timestamps
  end

  @required_fields ~w(name model_id manufacturer photo)
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
