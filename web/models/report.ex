defmodule Flexphoenix.Report do
  use Flexphoenix.Web, :model

  schema "reports" do
    field :title, :string
    field :description, :string
    field :location, :string
    field :type, :string
    field :instruction, :string
    field :priority, :string
    field :deadline, :string
    field :findings, :string
    field :actions, :string
    field :summary, :string
    field :completed, :string

    timestamps
  end

  @required_fields ~w(title description location instruction priority actions summary completed)
  @optional_fields ~w(type deadline findings)

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
